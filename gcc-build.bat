@echo off

:: Set build in 32-bit mode or not
set BUILD_32=1

if %BUILD_32% == 1 (
    echo Build in 32-bit mode
    set WRES_MODE=-F pe-i386
    set GXX_MODE=-m32
) else (
    echo Build in 64-bit mode
    set WRES_MODE=
    set GXX_MODE=
)

echo Delete last built file...
del NppPluginTemplate.dll

cd src

echo Compiling target file...
windres %WRES_MODE% NppPluginDemo.rc -o NppPluginDemo.o
g++ *.o *.cpp -DUNICODE -o ../NppPluginTemplate.dll ^
  %GXX_MODE% -static -shared -lshlwapi

echo Delete unused object files...
del *.o

cd ..

echo Open target file in explorer...
explorer /select, "NppPluginTemplate.dll"
