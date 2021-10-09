# Turing Machine Simulator in Haskell

This is a Turing Machine Simulator made using Haskell, a purely functional programming language.

### How to use and load: 
Load the program into a Haskell interpreter. \
I am using GHCi. \
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

***> "write the DSM File location:"***

```haskell 
DSM_add_1_binary.txt
```

3. Now insert the binary input that will be positioned on the tape.

***for example:*** let's insert the number ***2*** which in binary is represented by the code ***010*** :
```
010
```

4. The output tape will be printed:
```
"The output is :"
"0 1 1 x"
```
We can observe the the output tape is **011** the ***Binary*** equivalent to the number **3** in the **Decimal** system.

