@echo off
setlocal
cd /d "%~dp0"
title Fjern ErdetModLoader

if not exist "erdetspill-vanilla.pck" goto no_backup
if not exist "erdetspill.pck" goto no_game
if exist "erdetmodloader-remove.tmp" goto temp_exists

ren "erdetspill.pck" "erdetmodloader-remove.tmp"
if errorlevel 1 goto move_failed
ren "erdetspill-vanilla.pck" "erdetspill.pck"
if errorlevel 1 goto restore_failed
del /q "erdetmodloader-remove.tmp"
if exist "erdetmodloader-remove.tmp" goto delete_failed

if exist "erdetspill-modded.pck" del /q "erdetspill-modded.pck"
if exist "erdetspill-modded-backup.pck" del /q "erdetspill-modded-backup.pck"
if exist "override.cfg" del /q "override.cfg"
if exist "godot" rmdir /s /q "godot"
if exist "addons\mod_loader" rmdir /s /q "addons\mod_loader"
if exist "addons\JSON_Schema_Validator" rmdir /s /q "addons\JSON_Schema_Validator"
if exist "addons" rmdir "addons" 2>nul
if exist "loader_config" rmdir /s /q "loader_config"
if exist "INSTALL.md" del /q "INSTALL.md"
if exist "MODDING.md" del /q "MODDING.md"
if exist "SOURCE.txt" del /q "SOURCE.txt"
if exist "GODOT_MOD_LOADER_LICENSE.txt" del /q "GODOT_MOD_LOADER_LICENSE.txt"
if exist "INSTALL_MODLOADER.bat" del /q "INSTALL_MODLOADER.bat"

echo.
echo ErdetModLoader er fjernet. Mods-mappa er ikke slettet.
pause
(goto) 2>nul & del /q "%~f0"

:no_backup
echo Fant ikke erdetspill-vanilla.pck. Bruk Steam sin kontroll av spillfilene for a fa tilbake originalen.
pause
exit /b 1

:no_game
echo Fant ikke erdetspill.pck.
pause
exit /b 1

:temp_exists
echo Fant en gammel erdetmodloader-remove.tmp. Flytt eller slett den og prov igjen.
pause
exit /b 1

:move_failed
echo Klarte ikke a flytte den modifiserte spillfila. Lukk spillet og prov igjen.
pause
exit /b 1

:restore_failed
ren "erdetmodloader-remove.tmp" "erdetspill.pck"
echo Klarte ikke a sette tilbake originalen. Den modifiserte fila er aktivert igjen.
pause
exit /b 1

:delete_failed
echo Originalen er satt tilbake, men den gamle modifiserte fila kunne ikke slettes.
pause
exit /b 1
