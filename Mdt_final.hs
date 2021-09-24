import Data.String
import System.IO
import Data.List.Split

main = do

-- Specifing the (DSM) file that contains the dfn,sfn and mfn tables
    print "write the DSM File name:"
    xs <- getLine
    dsmFile <- readFile xs

-- Insert the input string that goes onto the tape
    print ""
    print "Write the Input tape:"
    xs <- getLine
    let ys = addSpaces xs
    let tape = words ys


    let resultDSM = dsmFile
    let x = splitOn "\n\n" resultDSM
    let stato_iniziale =   read (x!!0) :: Integer
    let halt_State =       read (x!!1) :: Integer
    let simbolo_speciale = read (x!!2) :: String
    let dfn =              read (x!!3) :: [(Integer, [([Char], Direction)])]
    let sfn =              read (x!!4) :: [(Integer, [([Char], Integer)])]
    let mfn =              read (x!!5) :: [(Integer, [([Char], [Char])])]

-- the configuration part of the MdT
    let macchina_di_Turing = MdT dfn sfn mfn halt_State simbolo_speciale

-- specify the position of the first symbol with the headNonSpeciale function
    let (simbolo_iniziale,posizione_iniziale) = headNonSpeciale simbolo_speciale tape 0

    print ""
    print "The output is :"
    print( unwords (runMdt tape stato_iniziale (posizione_iniziale) simbolo_iniziale (getFixedConfigOfMdT macchina_di_Turing)))

{-
runMdt
        tape
        stato_iniziale
        position_iniziale
        input
        config della MdT
-}

------------------------------------------------------------------------------

-- Add spaces between characters in the input string to be able to use the 'words' function
addSpaces [] = []
addSpaces (x:xs) = x:" " ++ addSpaces xs


{-
headNonSpeciale :: (Eq t1, Num t) => t1 -> [t1] -> t -> (t1, t)
headNonSpeciale specialChar (x:xs) pos
                                    | (specialChar == x) && (xs == []) = (x,pos)
                                    | (specialChar == x) && (xs /= []) = headNonSpeciale specialChar (xs) (pos+1)
                                    | otherwise = (x,pos)
-}

headNonSpeciale specialChar xss pos = head (dropWhile (\x -> fst(x) ==  specialChar ) (zip xss [0..]))


--Data type Direction ( R:right, L:left, N:none )
data Direction = R | L | N deriving (Show, Read)
instance Eq Direction where
    L == L = True
    R == R = True
    N == N = True
    _ == _ = False


-- Data structure that has the purpose of maintaining the configuration of the fixed parameters of the turing machine we use
--https://en.wikibooks.org/wiki/Haskell/More_on_datatypes#Named_Fields_(Record_Syntax)

data MdT = MdT
    [(Integer, [([Char], Direction)])]  --dfn
    [(Integer, [([Char], Integer)])]    --sfn
    [(Integer, [([Char], [Char])])]     --mfn
    Integer                             --halt State
    String                              --simbolo_speciale
  deriving (Show)

-- getFixedConfigOfMdT: returns a tuple with the fixed configurations of the MdT data structure
getFixedConfigOfMdT (MdT dfn sfn mfn halt_State simbolo_speciale) = (dfn, sfn, mfn, halt_State, simbolo_speciale)


ugualeTupla x y
            | x == fst (y) = True
            | x /= fst (y) = False

--search: legge il contenuto dalle tabelle
search :: Eq a => a -> [(a, b)] -> b
search input xs = snd ( head( (filter (ugualeTupla input) xs) ))


--dir: reads from the DFN in which direction the head of the machine move
dir :: (Eq a, Eq a1) => a1 -> a -> [(a1, [(a, b)])] -> b
dir state input dfn = search input (search state dfn)


--newStato: Read the new state from the SFN
newStato :: (Eq a, Eq a1) => a1 -> a -> [(a1, [(a, b)])] -> b
newStato state input sfn = search input (search state sfn )


--output: Read the output from the MFN
output :: (Eq a, Eq a1) => a1 -> a -> [(a1, [(a, b)])] -> b
output state input mfn = search input (search state mfn)


--replaceAtIndex: replaces the symbol in position n
replaceAtIndex :: Int -> a -> [a] -> [a]
replaceAtIndex n item ls = a ++ (item:b) where (a, (_:b)) = splitAt n ls


verificaInputTape tape state position (dfn, sfn, mfn, halt_State, simbolo_speciale) bool
                        = runMdt tape state posizione_nuova (tape!!posizione_nuova) configMdT
                        where
                        macchina_di_Turing = MdT dfn sfn mfn halt_State simbolo_speciale
                        configMdT = getFixedConfigOfMdT macchina_di_Turing
                        posizione_nuova =  isPositionOnTapeRight position bool


isPositionOnTapeRight position bool
                    | bool == False = (position+1)
                    | otherwise = position


--verificaPosOnTape: check the position on the tape (if the position is out to the tape it will add the special symbol in that position)
verificaPosOnTape tape state position (dfn, sfn, mfn, halt_State, simbolo_speciale)
                    | (position) < 0 = (verificaInputTape ([simbolo_speciale]++tape) state position configMdT False)
                    | (position) == length(tape) = (verificaInputTape (tape++[simbolo_speciale]) state position configMdT True)
                    | otherwise = (runMdt tape state position (tape!!(position)) configMdT)

                    where macchina_di_Turing = MdT dfn sfn mfn halt_State simbolo_speciale
                          configMdT = getFixedConfigOfMdT macchina_di_Turing


--runMdt :
runMdt tape state position input (dfn, sfn, mfn, halt_State, simbolo_speciale)

        | (state == halt_State) = tape
        | (R == (dir state input dfn)) = verificaPosOnTape replaceSimbolo nuovoStato (position+1) configMdT
        | (L == (dir state input dfn)) = verificaPosOnTape replaceSimbolo nuovoStato (position-1) configMdT
        | otherwise = runMdt replaceSimbolo nuovoStato (position) (tape!!(position)) configMdT

        where replaceSimbolo = replaceAtIndex position (output state input mfn) (tape)
              nuovoStato = newStato state input sfn
              macchina_di_Turing = MdT dfn sfn mfn halt_State simbolo_speciale
              configMdT = getFixedConfigOfMdT (macchina_di_Turing)

