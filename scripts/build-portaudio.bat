@echo off

REM Clone PortAudio if needed
if not exist portaudio (
    git clone https://github.com/PortAudio/portaudio.git
)

cd portaudio

REM Create and enter build directory
if not exist build mkdir build
cd build

REM Configure with CMake - enable shared libs and Windows APIs
cmake .. -G "Visual Studio 17 2022" -A x64 ^
    -DBUILD_SHARED_LIBS=ON ^
    -DPA_USE_ASIO=0 ^
    -DPA_USE_DS=1 ^
    -DPA_USE_WASAPI=1 ^
    -DPA_USE_WDMKS=1 ^
    -DPA_USE_WMME=1

REM Build Release configuration
cmake --build . --config Release

REM Create bin directory and copy libraries
if not exist ..\bin mkdir ..\bin
copy /Y Release\portaudio.dll ..\bin\portaudio.dll
copy /Y Release\portaudio.lib ..\bin\portaudio.lib

cd ..\..