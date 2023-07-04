# The WI-FI Brute Forcer By TUX

- Thanks to TheBATeam, especially [AACINI](https://aacini.org/) for making this UI possible.



## Commands

- help             : Displays this area
- wifiscan         : Performs a WI-FI scan
- interface	   : Interface management
- attack           : Attacks selected WI-FI


## About Brute Forcer
	
- This program performs an "Online Attack" on the target WI-FI.
- It's speed depends on your hardware.
- Not 100% accurate because it's a brute force attack.
- A big password file isn't included, you can create it with "keycombinator.cmd" or
you can download it from the internet and rename it "passlist.txt" and paste it inside "BF_Files"
- Because Online Attack is so slow, big password lists are not recommended.
- Your attack results are being written to "WIFI_Report.txt" inside "BF_Files"
- Please, do not touch other files, it may cause malfunctioning!
- "keycombinator.cmd" creates a list inside BF_Files with the name "passlist_raw.txt".
You have to rename it to "passlist.txt"
## Help with errors

### Unsupported Char

- This means that the target SSID includes an unsupported character by Command Prompt
- To prevent the program from malfunctioning, those SSIDs are banned.


### Deleting Profile

- If you are trying to attack a network that has the same name 
of a network you have already connected to, the program deletes your previous profile.
- Your previous password will be deleted.


### MAC Spoofing

- MAC Spoofing is using a different MAC Address rather than the original one which your interface has.
- It helps you to stay anonymous while attacking.
- If you accidentally disable your wi-fi interface, open cmd and type this
netsh interface set interface name="Wi-Fi" admin=Enabled
		
- If you have multiple Wi-Fi interfaces, it may be Wi-Fi 2 or etc. (Wi-Fi 3,4,5...)
