# Turing Machine Simulator in Haskell

This is a Turing Machine Simulator made using Haskell, a purely functional programming language.

### How to use and load: 
Load the program into a Haskell interpreter. \
I am using GHCi. 
 ``` 
gchi Mdt_final.hs
 ``` 


#### The example below is a machine which adds 1 to the binary number on the tape 

1. Call the main 
```
main
```
2. Specify the *DSM file* that contains the *dfn*,*sfn* and *mfn* tables, in our case will be the file 
[*DSM_add_1_binary.txt*](https://github.com/SimonDahdal/Turing-Machine-Simulator-in-Haskell/blob/main/DSM_add_1_binary.txt)

&nbsp;&nbsp;***> "write the DSM File location:"***

```haskell 
DSM_add_1_binary.txt
```

3. Insert the binary input that will be positioned on the tape.

&nbsp;&nbsp;***for example:*** let's insert the number ***2*** which in binary is represented by the code ***010*** :
```
010
```

4. The output tape will be printed:
```
"The output is :"
"0 1 1 x"
```
We can see that the output tape is **011** that is the ***Binary*** equivalent to the number **3** in the **Decimal** system.

## DMS File Structure

The file should have the same structure as follow:

* **Inital State** : ```Integer```
* **Halt State** : ```Integer```
* **Special Symbol** : ```String```
* **Direction Function *DFN*** : ```[(Integer, [([Char], Direction)])]```
    * *R : Right*
    * *L : Left*
    * *N : None* 
* **State Function *SFN*** : ```[(Integer, [([Char], Integer)])] ```
* **Machine Function *MFN*** : ```[(Integer, [([Char], [Char])])]```

#### Example:
```
1

3

"x"

[   (1, [("0",R),("1",R),("x",L)]),
    (2, [("0",L),("1",L),("x",L)]),
    (3, [("0",L),("1",L),("x",N)])
]

[  (1, [("0",1),("1",1),("x",2)]),
   (2, [("0",3),("1",2),("x",3)]),
   (3, [("0",3),("1",3),("x",3)]) 
]

[   (1, [("0","0"),("1","1"),("x","x")]),
    (2, [("0","1"),("1","0"),("x","1")]),
    (3, [("0","0"),("1","1"),("x","x")])
]
```

