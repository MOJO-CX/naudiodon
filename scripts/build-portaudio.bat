@echo off

REM Clone PortAudio if needed
if not exist portaudio (
    git clone https://github.com/PortAudio/portaudio.git
)

cd portaudio

REM Create and enter build directory
if not exist build mkdir build
cd build

REM Configure and build with CMake
cmake .. -G "Visual Studio 17 2022" -A x64
cmake --build . --config Release

REM Create bin directory and copy libraries
if not exist ..\bin mkdir ..\bin
copy /Y Release\portaudio.dll ..\bin\portaudio_x64.dll
copy /Y Release\portaudio.lib ..\bin\portaudio_x64.lib 