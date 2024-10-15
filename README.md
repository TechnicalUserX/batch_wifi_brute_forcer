# Batch Wi-Fi Brute Forcer
An active attack tool against Wi-Fi networks with internal CMD commands.

## Usage

### 1) Interface initialization
The program automatically detects your wireless interfaces when you execute the batch file.
If it finds only one, it will select it as default. If there are multiple interfaces,
the program will ask you to choose one. If none exist, it will stay "not_defined".

> You can later change the interface by typing `interface` on the main menu.
> This will bring the interface initialization screen back.

### 2) Scan
When you type `scan` at the main menu, the program will enumerate all Wi-Fi networks
available from the selected wireless interface. You can choose one by typing the number
associated with an SSID.

> No Name could mean that the network is hidden. You cannot attack that network.

### 3) Selecting a wordlist
You have to specify the wordlist file you are going to use by typing `wordlist` on the 
main menu. You can provide a file which is relatively positioned in the program directory
or you can give full path.
> You don't have to specify a wordlist file if you have a default wordlist.

### 4) Selecting a default wordlist
You can specify a default wordlist by changing the value
inside of DefaultWordlist.txt. You can provide a file 
which is relatively positioned in the program directory or you can give full path. 
This way, you will not need to specify a wordlist file every time you open the program.
> If you see the wordlist selection menu when you open the program, it means that the default wordlist is invalid.

### 5) Attacking
Simply type `attack` and program will show you a warning screen that this process is going
to delete the profile associated with the SSID if you have connected to it before.
It means you will lose the password you entered while connecting to that SSID before.
Save it before using the attack.

## Limitations
- This program has been tested unsuccessfully on Windows 7 and tested successfully on Windows 10 and 11. Since some commands may differ in terms of output between Windows versions, it is not expected to work on previous versions.

- This program uses ANSI escape sequences in the terminal which was added to the Windows Console in the Windows 10 version 1511, previous versions are not expected to run this program.

- Speed is significantly slow due to its nature.

- Cannot attack hidden networks.

## Result file
If an attack was successful, the result is automatically written to `result.txt`.


## Help screen
```txt
Commands

 - help             : Displays this page
 - wordlist         : Provide a wordlist file  
 - scan             : Performs a WI-FI scan    
 - interface        : Open Interface Management
 - attack           : Attacks selected WI-FI

 For more informaton, please read "README.md". 

 Other projects of TUX:
 https://www.technicaluserx.wordpress.com      
 https://github.com/TechnicalUserX


Press any key to continue...
```
