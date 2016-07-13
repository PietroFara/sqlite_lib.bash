# sqlite_lib.bash
Bash library to use SQLite in bash scripts

Dependencies: 
  - sqlite3
  
Tested with sqlite 3.13.0 in ArchLinux

## Usage:
Import the library into your script
``` bash
source sqlite_lib.bash
```
Call sqlite_create_fetch_array with two parameters: the first is the sqlite db file, the second is the sqlite query (must be in quotes). 
``` bash
sqlite_create_fetch_array db.sqlite "SELECT id, Name, Surname FROM Customers"
```
The function sets two variables: 
  1. *num_rows* contains the number of rows of the query result
  2. *rows* (bidimensional array) contains the data. The first index is the row result index, the second is the Column name of the result data
``` bash
for (( i = 0; i < num_rows; i++ )); do
  echo ${rows[$i,"id"]} ${rows[$i,"Name"]} ${rows[$i,"Surname"]} 
done
```
## Full example:
``` bash
#!/bin/bash
source sqlite_lib.bash
sqlite_create_fetch_array db.sqlite "SELECT id, Name, Surname FROM Customers"
for (( i = 0; i < num_rows; i++ )); do
  echo ${rows[$i,"id"]} ${rows[$i,"Name"]} ${rows[$i,"Surname"]} 
done
```
