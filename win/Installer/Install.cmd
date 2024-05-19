@echo off

cd /d %~dp0

REM Check admin permission//////////////////////////////////////////////////////////////////////////////////////////////
fltmc >nul 2>&1
if not %errorLevel% == 0 (
	echo "User does not have admin permission."
	echo "You can install apps full automatically by running this script as admin (except for Spotify)."
	pause
)

REM Cleanup//////////////////////////////////////////////////////////////////////////////////////////////
choice /C AYN /M "Do you want to cleanup? [A]ll [Y]es [N]o" /N
set cleanup=%errorlevel%
if "%cleanup%"=="1" (
	set unins_util=1
	set unins_office=1
	set unins_multimedia=1
	set unins_entertainment=1
	set unins_xbox=1
	goto do_cleanup
) else if "%cleanup%"=="3" (
	echo Skipping cleanup.
	goto ask_powershell
)

choice /C YN /M "Do you want to uninstall Utilities (Camera, VoiceMemo, Clock)?"
set unins_util=%errorlevel%
choice /C YN /M "Do you want to uninstall Office (Office, Teams)?"
set unins_office=%errorlevel%
choice /C YN /M "Do you want to uninstall Multi media viewer (Clipchamp, Photos, Paint)?"
set unins_multimedia=%errorlevel%
choice /C YN /M "Do you want to uninstall Entertainment (Disney+, Spotify, Movie, TV)?"
set unins_entertainment=%errorlevel%
choice /C YN /M "Do you want to uninstall Xbox (Xbox, XboxGameOverlay)?"
set unins_xbox=%errorlevel%

:do_cleanup
if "%unins_util%"=="1" (
	echo Uninstalling Utilities...
	powershell -ExecutionPolicy RemoteSigned -File Uninstall_Utility.ps1
	echo Done.
) else (
	echo Skipping Utilities.
)
if "%unins_office%"=="1" (
	echo Uninstalling Office...
	powershell -ExecutionPolicy RemoteSigned -File Uninstall_Office.ps1
	echo Done.
) else (
	echo Skipping Office.
)
if "%unins_multimedia%"=="1" (
	echo Uninstalling Multimedia...
	powershell -ExecutionPolicy RemoteSigned -File Uninstall_MultimediaViewer.ps1
	echo Done.
) else (
	echo Skipping Multimedia.
)
if "%unins_entertainment%"=="1" (
	echo Uninstalling Entertainment...
	powershell -ExecutionPolicy RemoteSigned -File Uninstall_Entertainment.ps1
	echo Done.
) else (
	echo Skipping Entertainment.
)
if "%unins_xbox%"=="1" (
	echo Uninstalling Xbox...
	powershell -ExecutionPolicy RemoteSigned -File Uninstall_Xbox.ps1
	echo Done.
) else (
	echo Skipping Xbox.
)

REM Powershell//////////////////////////////////////////////////////////////////////////////////////////////
:ask_powershell
choice /C AYN /M "Do you want to setup Powershell and Terminal? [A]ll [Y]es [N]o" /N
set setup_ps=%errorlevel%
if "%setup_ps%"=="1" (
	set ins_ps=1
	set ins_psmodule=1
	set ins_omp=1
	set ins_psprofile=1
	set ins_wtprofile=1
	goto do_powershell
) else if "%setup_ps%"=="3" (
	echo Skipping Powershell setup.
	goto ask_driver
)

choice /C YN /M "Do you want to install the latest Powershell?"
set ins_ps=%errorlevel%
choice /C YN /M "Do you want to install Powershell Modules?"
set ins_psmodule=%errorlevel%
choice /C YN /M "Do you want to install Oh My Posh?"
set ins_omp=%errorlevel%
choice /C YN /M "Do you want to install Powershell Profile?"
set ins_psprofile=%errorlevel%
choice /C YN /M "Do you want to install Windows Terminal Profile?"
set ins_wtprofile=%errorlevel%

:do_powershell
if "%ins_ps%"=="1" (
	echo Installing Powershell...
	powershell winget install Microsoft.PowerShell
	echo Done.
) else (
	echo Skipping Powershell.
)
if "%ins_psmodule%"=="1" (
	echo Installing Powershell Modules...
	powershell -ExecutionPolicy RemoteSigned -File Install_PSModule.ps1 -ForPWSH True
	echo Done.
) else (
	echo Skipping Powershell Modules.
)
if "%ins_omp%"=="1" (
	echo Installing Oh My Posh...
	powershell -ExecutionPolicy RemoteSigned -File Install_OhMyPosh.ps1
	echo Done.
) else (
	echo Skipping Oh My Posh.
)
if "%ins_psprofile%"=="1" (
	echo Installing Powershell Profile...
	if not exist "%USERPROFILE%\Documents\Powershell" mkdir "%USERPROFILE%\Documents\Powershell"
	if exist "%USERPROFILE%\Documents\Powershell\Microsoft.Powershell_profile.ps1" del "%USERPROFILE%\Documents\Powershell\Microsoft.Powershell_profile.ps1"
	if exist "%USERPROFILE%\Documents\WindowsPowershell\Microsoft.Powershell_profile.ps1" del "%USERPROFILE%\Documents\WindowsPowershell\Microsoft.Powershell_profile.ps1"
	if exist "%USERPROFILE%\Documents\Powershell\Microsoft.VSCode_profile.ps1" del "%USERPROFILE%\Documents\Powershell\Microsoft.VSCode_profile.ps1"
	mklink /H "%USERPROFILE%\Documents\Powershell\Microsoft.Powershell_profile.ps1" "..\Microsoft.Powershell_profile.ps1"
	mklink /H "%USERPROFILE%\Documents\WindowsPowershell\Microsoft.Powershell_profile.ps1" "..\Microsoft.Powershell_profile.ps1"
	mklink /H "%USERPROFILE%\Documents\Powershell\Microsoft.VSCode_profile.ps1" "..\Microsoft.Powershell_profile.ps1"
	echo Done.
) else (
	echo Skipping Powershell Profile.
)
if "%ins_wtprofile%"=="1" (
	echo Installing Windows Terminal Profile...
	REM Search for Windows Terminal folder
	for /D %%G in ("%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal*") do (
		REM Make symbolic link from ../WindowsTerminal_profile.json to settings.json
		if exist "%%G\LocalState\settings.json" del "%%G\LocalState\settings.json"
		mklink /H "%%G\LocalState\settings.json" "..\WindowsTerminal_profile.json"
	)
	echo Done.
) else (
	echo Skipping Windows Terminal Profile.
)



REM AskApp//////////////////////////////////////////////////////////////////////////////////////////////
:ask_driver
choice /C AYN /M "Do you want to install drivers? (GeForce, iCUE, Razer, GoogleJpaneseInput, Wacom) [A]ll [Y]es [N]o" /N
set setup_dirver=%errorlevel%
if "%setup_dirver%"=="1" (
	set ins_geforce=1
	set ins_icue=1
	set ins_razersynapse=1
	set ins_gjainput=1
	set ins_wacom=1
	goto ask_authapp
) else if "%setup_dirver%"=="3" (
	echo Skipping driver setup.
	goto ask_authapp
)

choice /C YN /M "Do you want to install GeForce Experience?"
set ins_geforce=%errorlevel%
choice /C YN /M "Do you want to install iCUE?"
set ins_icue=%errorlevel%
choice /C YN /M "Do you want to install Razer Synapse?"
set ins_razersynapse=%errorlevel%
choice /C YN /M "Do you want to install Google Japanese Input?"
set ins_gjainput=%errorlevel%
choice /C YN /M "Do you want to install Wacom Tablet?"
set ins_wacom=%errorlevel%

:ask_authapp
choice /C AYN /M "Do you want to install authentication apps? (Authy, Bitwarden) [A]ll [Y]es [N]o" /N
set setup_authapp=%errorlevel%
if "%setup_authapp%"=="1" (
	set ins_authy=1
	set ins_bitwarden=1
	goto ask_browser
) else if "%setup_authapp%"=="3" (
	echo Skipping authentication app setup.
	goto ask_browser
)

choice /C YN /M "Do you want to install Authy?"
set ins_authy=%errorlevel%
choice /C YN /M "Do you want to install Bitwarden?"
set ins_bitwarden=%errorlevel%

:ask_browser
choice /C AYN /M "Do you want to install browsers? (Chrome, Firefox) [A]ll [Y]es [N]o" /N
set setup_browser=%errorlevel%
if "%setup_browser%"=="1" (
	set ins_chrome=1
	set ins_firefox=1
	goto ask_cloud
) else if "%setup_browser%"=="3" (
	echo Skipping browser setup.
	goto ask_cloud
)

choice /C YN /M "Do you want to install Google Chrome?"
set ins_chrome=%errorlevel%
choice /C YN /M "Do you want to install Mozilla Firefox?"
set ins_firefox=%errorlevel%

:ask_cloud
choice /C AYN /M "Do you want to install cloud apps? (OneDrive, Dropbox, Google Drive) [A]ll [Y]es [N]o" /N
set setup_cloud=%errorlevel%
if "%setup_cloud%"=="1" (
	set ins_onedrive=1
	set ins_dropbox=1
	set ins_gdrive=1
	goto ask_development
) else if "%setup_cloud%"=="3" (
	echo Skipping cloud app setup.
	goto ask_development
)

choice /C YN /M "Do you want to install OneDrive?"
set ins_onedrive=%errorlevel%
choice /C YN /M "Do you want to install Dropbox?"
set ins_dropbox=%errorlevel%
choice /C YN /M "Do you want to install Google Drive?"
set ins_gdrive=%errorlevel%

:ask_development
choice /C AYN /M "Do you want to install development apps? (Git, Github CLI, Visual Studio Code, Visual Studio, Vim) [A]ll [Y]es [N]o" /N
set setup_development=%errorlevel%
if "%setup_development%"=="1" (
	set ins_git=1
	set ins_gh=1
	set ins_vscode=1
	set ins_vs=1
	set ins_vim=1
	goto ask_programming
) else if "%setup_development%"=="3" (
	echo Skipping development app setup.
	goto ask_programming
)

choice /C YN /M "Do you want to install Git?"
set ins_git=%errorlevel%
choice /C YN /M "Do you want to install Github CLI?"
set ins_gh=%errorlevel%
choice /C YN /M "Do you want to install Visual Studio Code?"
set ins_vscode=%errorlevel%
choice /C YN /M "Do you want to install Visual Studio?"
set ins_vs=%errorlevel%
choice /C YN /M "Do you want to install Vim?"
set ins_vim=%errorlevel%

:ask_programming
choice /C AYN /M "Do you want to install programming apps? (Java, Python3, Node.js, .NET) [A]ll [Y]es [N]o" /N
set setup_programming=%errorlevel%
if "%setup_programming%"=="1" (
	set java=1
	set javaV=21
	set python=1
	set pythonV=12
	set node=1
	set dotnet=1
	set dotnetV=8
	goto ask_virtualization
) else if "%setup_programming%"=="3" (
	echo Skipping programming app setup.
	goto ask_virtualization
)

choice /C YN /M "Do you want to install Java?"
set java=%errorlevel%
:java_version
set /p javaV=Which version of Java do you want to install? (11/16/21):
if "%javaV%"=="11" (
	echo Java 11 selected.
) else if "%javaV%"=="16" (
	echo Java 16 selected.
) else if "%javaV%"=="21" (
	echo Java 21 selected.
) else (
	echo Invalid Java version. Please select 11, 16, or 21.
	goto java_version
)
choice /C YN /M "Do you want to install Python3?"
set python=%errorlevel%
:python_version
set /p pythonV=Which version of Python do you want to install? 3.(0-12):
if "%pythonV%"=="0" (
	echo Python 3.0 selected.
) else if "%pythonV%"=="1" (
	echo Python 3.1 selected.
) else if "%pythonV%"=="2" (
	echo Python 3.2 selected.
) else if "%pythonV%"=="3" (
	echo Python 3.3 selected.
) else if "%pythonV%"=="4" (
	echo Python 3.4 selected.
) else if "%pythonV%"=="5" (
	echo Python 3.5 selected.
) else if "%pythonV%"=="6" (
	echo Python 3.6 selected.
) else if "%pythonV%"=="7" (
	echo Python 3.7 selected.
) else if "%pythonV%"=="8" (
	echo Python 3.8 selected.
) else if "%pythonV%"=="9" (
	echo Python 3.9 selected.
) else if "%pythonV%"=="10" (
	echo Python 3.10 selected.
) else if "%pythonV%"=="11" (
	echo Python 3.11 selected.
) else if "%pythonV%"=="12" (
	echo Python 3.12 selected.
) else (
	echo Invalid Python version. Please select 0-12.
	goto python_version
)
choice /C YN /M "Do you want to install Node.js?"
set node=%errorlevel%
choice /C YN /M "Do you want to install .NET?"
set dotnet=%errorlevel%
:dotnet_version
set /p dotnetV=Which version of .NET do you want to install? (7/8):
if "%dotnetV%"=="7" (
	echo .NET 7 selected.
) else if "%dotnetV%"=="8" (
	echo .NET 8 selected.
) else (
	echo Invalid .NET version. Please select 7 or 8.
	goto dotnet_version
)

:ask_virtualization
choice /C AYN /M "Do you want to install virtualization apps? (VirtualBox, Docker) [A]ll [Y]es [N]o" /N
set setup_virtualization=%errorlevel%
if "%setup_virtualization%"=="1" (
	set ins_virtualbox=1
	set ins_docker=1
	goto ask_office
) else if "%setup_virtualization%"=="3" (
	echo Skipping virtualization app setup.
	goto ask_office
)

choice /C YN /M "Do you want to install VirtualBox?"
set ins_virtualbox=%errorlevel%
choice /C YN /M "Do you want to install Docker?"
set ins_docker=%errorlevel%

:ask_office
choice /C AYN /M "Do you want to install office apps? (Office, OneNote, Teams, Zoom) [A]ll [Y]es [N]o" /N
set setup_office=%errorlevel%
if "%setup_office%"=="1" (
	set ins_office=1
	set ins_onenote=1
	set ins_teams=1
	set ins_zoom=1
	goto ask_creative
) else if "%setup_office%"=="3" (
	echo Skipping office app setup.
	goto ask_creative
)

choice /C YN /M "Do you want to install Microsoft Office (Only Excel, Word, Powerpoint)?"
set ins_office=%errorlevel%
choice /C YN /M "Do you want to install Microsoft OneNote?"
set ins_onenote=%errorlevel%
choice /C YN /M "Do you want to install Microsoft Teams?"
set ins_teams=%errorlevel%
choice /C YN /M "Do you want to install Zoom?"
set ins_zoom=%errorlevel%

:ask_creative
choice /C AYN /M "Do you want to install creative apps? (Adobe Creative Cloud, Blender, Unity, Unreal Engine) [A]ll [Y]es [N]o" /N
set setup_creative=%errorlevel%
if "%setup_creative%"=="1" (
	set ins_adobe=1
	set ins_blender=1
	set ins_unity=1
	set ins_unreal=1
	goto ask_game
) else if "%setup_creative%"=="3" (
	echo Skipping creative app setup.
	goto ask_game
)

choice /C YN /M "Do you want to install Adobe Creative Cloud?"
set ins_adobe=%errorlevel%
choice /C YN /M "Do you want to install Blender?"
set ins_blender=%errorlevel%
choice /C YN /M "Do you want to install Unity?"
set ins_unity=%errorlevel%
choice /C YN /M "Do you want to install Unreal Engine?"
set ins_unreal=%errorlevel%

:ask_game
choice /C AYN /M "Do you want to install game apps? (Steam, Epic Games, Minecraft, LoL, Blitz.gg) [A]ll [Y]es [N]o" /N
set setup_game=%errorlevel%
if "%setup_game%"=="1" (
	set ins_steam=1
	set ins_epic=1
	set ins_minecraft=1
	set ins_lol=1
	set ins_blitz=1
	goto ask_other
) else if "%setup_game%"=="3" (
	echo Skipping game app setup.
	goto ask_other
)

choice /C YN /M "Do you want to install Steam?"
set ins_steam=%errorlevel%
choice /C YN /M "Do you want to install Epic Games?"
set ins_epic=%errorlevel%
choice /C YN /M "Do you want to install Minecraft?"
set ins_minecraft=%errorlevel%
choice /C YN /M "Do you want to install LoL?"
set ins_lol=%errorlevel%
choice /C YN /M "Do you want to install Blitz.gg?"
set ins_blitz=%errorlevel%

:ask_other
choice /C AYN /M "Do you want to install other apps? (Notion, Spotify) [A]ll [Y]es [N]o" /N
set setup_other=%errorlevel%
if "%setup_other%"=="1" (
	set ins_notion=1
	set ins_spotify=1
	goto ask_communication
) else if "%setup_other%"=="3" (
	echo Skipping other app setup.
	goto ask_communication
)

choice /C YN /M "Do you want to install Notion?"
set ins_notion=%errorlevel%
choice /C YN /M "Do you want to install Spotify?"
set ins_spotify=%errorlevel%

:ask_communication
choice /C AYN /M "Do you want to install communication apps? (LINE, Discord) [A]ll [Y]es [N]o" /N
set setup_communication=%errorlevel%
if "%setup_communication%"=="1" (
	set ins_line=1
	set ins_discord=1
	goto do_app
) else if "%setup_communication%"=="3" (
	echo Skipping communication app setup.
	goto do_app
)
choice /C YN /M "Do you want to install LINE?"
set ins_line=%errorlevel%
choice /C YN /M "Do you want to install Discord?"
set ins_discord=%errorlevel%

REM Driver//////////////////////////////////////////////////////////////////////////////////////////////
:do_app
if "%ins_geforce%"=="1" (
	echo Installing GeForce Experience...
	powershell winget install NVIDIA.GeForceExperience
	echo Done.
) else (
	echo Skipping GeForce Experience.
)
if "%ins_icue%"=="1" (
	echo Installing iCUE...
	powershell winget install Corsair.iCUE.4
	echo Done.
) else (
	echo Skipping iCUE.
)
if "%ins_razersynapse%"=="1" (
	echo Installing Razer Synapse...
	powershell winget install RazerInc.RazerInstaller
	echo Done.
) else (
	echo Skipping Razer Synapse.
)
if "%ins_gjainput%"=="1" (
	echo Installing Google Japanese Input...
	powershell winget install Google.JapaneseIME
	echo Done.
) else (
	echo Skipping Google Japanese Input.
)
if "%ins_wacom%"=="1" (
	echo Installing Wacom Tablet...
	powershell winget install Wacom.WacomTabletDriver
	echo Done.
) else (
	echo Skipping Wacom Tablet.
)

REM Authentication//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_authy%"=="1" (
	echo Installing Authy...
	powershell winget install Twilio.Authy
	echo Done.
) else (
	echo Skipping Authy.
)
if "%ins_bitwarden%"=="1" (
	echo Installing Bitwarden...
	powershell winget install Bitwarden.Bitwarden
	echo Done.
) else (
	echo Skipping Bitwarden.
)

REM Browser//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_chrome%"=="1" (
	echo Installing Google Chrome...
	powershell winget install Google.Chrome
	echo Done.
) else (
	echo Skipping Google Chrome.
)
if "%ins_firefox%"=="1" (
	echo Installing Mozilla Firefox...
	powershell winget install Mozilla.Firefox
	echo Done.
) else (
	echo Skipping Mozilla Firefox.
)

REM Cloud//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_onedrive%"=="1" (
	echo Installing OneDrive...
	powershell winget install Microsoft.OneDrive
	echo Done.
) else (
	echo Skipping OneDrive.
)
if "%ins_dropbox%"=="1" (
	echo Installing Dropbox...
	powershell winget install Dropbox.Dropbox
	echo Done.
) else (
	echo Skipping Dropbox.
)
if "%ins_gdrive%"=="1" (
	echo Installing Google Drive...
	powershell winget install Google.GoogleDrive
	echo Done.
) else (
	echo Skipping Google Drive.
)

if "%ins_git%"=="1" (
	echo Installing Git...
	powershell winget install Git.Git
	echo Done.
) else (
	echo Skipping Git.
)
if "%ins_gh%"=="1" (
	echo Installing Github CLI...
	powershell winget install GitHub.cli
	echo Done.
) else (
	echo Skipping Github CLI.
)

REM Development//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_vscode%"=="1" (
	echo Installing Visual Studio Code...
	powershell winget install Microsoft.VisualStudioCode
	echo Done.
) else (
	echo Skipping Visual Studio Code.
)
if "%ins_vs%"=="1" (
	echo Installing Visual Studio...
	powershell winget install Microsoft.VisualStudio.2022.Community
	echo Done.
) else (
	echo Skipping Visual Studio.
)
if "%ins_vim%"=="1" (
	echo Installing Vim...
	powershell winget install vim.vim
	echo Done.
) else (
	echo Skipping Vim.
)

REM Programming//////////////////////////////////////////////////////////////////////////////////////////////
if "%java%"=="1" (
	echo Installing Java...
	powershell winget install Microsoft.OpenJDK.%javaV%
	echo Done.
) else (
	echo Skipping Java.
)
if "%python%"=="1" (
	echo Installing Python3...
	powershell winget install Python.Python.3.%pythonV%
	echo Done.
) else (
	echo Skipping Python3.
)
if "%node%"=="1" (
	echo Installing Node.js...
	powershell winget install OpenJS.NodeJS.LTS
	echo Done.
) else (
	echo Skipping Node.js.
)
if "%dotnet%"=="1" (
	echo Installing .NET...
	powershell winget install Microsoft.DotNet.SDK.%dotnetV%
	echo Done.
) else (
	echo Skipping .NET.
)

REM Virtualization//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_virtualbox%"=="1" (
	echo Installing VirtualBox...
	powershell winget install Oracle.VirtualBox
	echo Done.
) else (
	echo Skipping VirtualBox.
)
if "%ins_docker%"=="1" (
	echo Installing Docker...
	powershell winget install Docker.DockerDesktop
	echo Done.
) else (
	echo Skipping Docker.
)

REM Office//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_office%"=="1" (
	if "%ins_onenote%"=="1" (
		echo Installing Microsoft Office with OneNote...
		powershell winget install Microsoft.Office --override "/configure OfficeConfig/OnlyExcelWordPowerpointOnenote.xml"
		echo Done.
	) else (
		echo Installing Microsoft Office...
		powershell winget install Microsoft.Office --override "/configure OfficeConfig/OnlyExcelWordPowerpoint.xml"
		echo Done.
	)
) else if "%ins_onenote%"=="1" (
	echo Installing OneNote...
	powershell winget install Microsoft.Office --override "/configure OfficeConfig/OnlyOnenote.xml"
	echo Done.
) else (
	echo Skipping Microsoft Office and OneNote.
)
if "%ins_teams%"=="1" (
	echo Installing Microsoft Teams...
	powershell winget install Microsoft.Teams
	echo Done.
) else (
	echo Skipping Microsoft Teams.
)
if "%ins_zoom%"=="1" (
	echo Installing Zoom...
	powershell winget install Zoom.Zoom
	echo Done.
) else (
	echo Skipping Zoom.
)

REM Creative//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_adobe%"=="1" (
	echo Installing Adobe Creative Cloud...
	powershell winget install "Adobe Creative Cloud"
	echo Done.
) else (
	echo Skipping Adobe Creative Cloud.
)
if "%ins_blender%"=="1" (
	echo Installing Blender...
	powershell winget install BlenderFoundation.Blender
	echo Done.
) else (
	echo Skipping Blender.
)
if "%ins_unity%"=="1" (
	echo Installing Unity...
	powershell winget install Unity.UnityHub
	echo Done.
) else (
	echo Skipping Unity.
)
if "%ins_unreal%"=="1" (
	echo Installing Unreal Engine...
	powershell winget install EpicGames.EpicGamesLauncher
	echo Done.
) else (
	echo Skipping Unreal Engine.
)

REM Game//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_steam%"=="1" (
	echo Installing Steam...
	powershell winget install Valve.Steam
	echo Done.
) else (
	echo Skipping Steam.
)
if "%ins_epic%"=="1" (
	if not "%ins_unreal%"=="1" (
		echo Installing Unreal Engine...
		powershell winget install EpicGames.EpicGamesLauncher
		echo Done.
	)
) else (
	echo Skipping Epic Games.
)
if "%ins_minecraft%"=="1" (
	echo Installing Minecraft...
	powershell winget install Mojang.MinecraftLauncher
	echo Done.
) else (
	echo Skipping Minecraft.
)
if "%ins_lol%"=="1" (
	echo Installing LoL...
	powershell winget install RiotGames.LeagueOfLegends.JP
	echo Done.
) else (
	echo Skipping LoL.
)
if "%ins_blitz%"=="1" (
	echo Installing Blitz.gg...
	powershell winget install Blitz.Blitz
	echo Done.
) else (
	echo Skipping Blitz.gg.
)

REM Other//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_notion%"=="1" (
	echo Installing Notion...
	powershell winget install Notion.Notion
	echo Done.
) else (
	echo Skipping Notion.
)
if "%ins_spotify%"=="1" (
	echo Installing Spotify...
	powershell winget install Spotify.Spotify
	echo Done.
) else (
	echo Skipping Spotify.
)

REM Communication//////////////////////////////////////////////////////////////////////////////////////////////
if "%ins_line%"=="1" (
	echo Installing LINE...
	powershell winget install LINE.LINE
	echo Done.
) else (
	echo Skipping LINE.
)
if "%ins_discord%"=="1" (
	echo Installing Discord...
	powershell winget install Discord.Discord
	echo Done.
) else (
	echo Skipping Discord.
)

REM Setup//////////////////////////////////////////////////////////////////////////////////////////////
choice /C YN /M "Do you want to setup Git?"
set setup_git=%errorlevel%

if "%setup_git%"=="1" (
	echo Setting up Git...
	powershell -ExecutionPolicy RemoteSigned -File SetUp_Github.ps1
	echo Done.
) else (
	echo Skipping Git setup.
)

pause