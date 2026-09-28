@echo off
setlocal
cd /d "%~dp0"
title ErdetModLoader

if not exist "erdetspill.exe" goto wrong_folder
if not exist "erdetspill.pck" goto missing_game
if exist "erdetspill-vanilla.pck" goto already_installed
if exist "erdetspill-modded.pck" goto leftover_file
if not exist "loader_config\project.binary" goto broken_package
if not exist "loader_config\global_script_class_cache.cfg" goto broken_package
if not exist "addons\mod_loader\vendor\GDRE\gdre_tools.exe" goto broken_package

echo Installerer modloaderen. Dette kan ta litt tid.
start /wait "" "addons\mod_loader\vendor\GDRE\gdre_tools.exe" --headless "--pck-patch=%CD%\erdetspill.pck" "--patch-file=%CD%\loader_config\project.binary=res://project.binary" "--patch-file=%CD%\loader_config\global_script_class_cache.cfg=res://.godot/global_script_class_cache.cfg" "--output=%CD%\erdetspill-modded.pck"

if not exist "erdetspill-modded.pck" goto patch_failed
ren "erdetspill.pck" "erdetspill-vanilla.pck"
if errorlevel 1 goto rename_failed
ren "erdetspill-modded.pck" "erdetspill.pck"
if errorlevel 1 goto restore_original
if not exist "mods" mkdir "mods"

echo.
echo Ferdig. Legg mod-ZIP-er i mods-mappa og start spillet gjennom Steam.
pause
exit /b 0

:wrong_folder
echo Fant ikke erdetspill.exe. Pakk ut filene i spillmappa som Steam apner.
pause
exit /b 1

:missing_game
echo Fant ikke erdetspill.pck. Kjor Steam sin kontroll av spillfilene og prov igjen.
pause
exit /b 1

:already_installed
echo Modloaderen ser ut til a vaere installert allerede.
pause
exit /b 0

:leftover_file
echo Fant erdetspill-modded.pck fra et tidligere forsok. Flytt eller slett den og prov igjen.
pause
exit /b 1

:broken_package
echo Det mangler filer fra modloader-ZIP-en. Pakk ut hele ZIP-en pa nytt.
pause
exit /b 1

:patch_failed
echo Klarte ikke a lage den modifiserte PCK-fila. Ingen spillfiler ble byttet ut.
pause
exit /b 1

:rename_failed
echo Klarte ikke a lage backup av originalen. Den modifiserte fila ligger som erdetspill-modded.pck.
pause
exit /b 1

:restore_original
ren "erdetspill-vanilla.pck" "erdetspill.pck"
echo Klarte ikke a aktivere modloaderen. Den originale spillfila er satt tilbake.
pause
exit /b 1
