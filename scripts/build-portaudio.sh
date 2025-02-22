#!/bin/bash

# Clone PortAudio if needed
if [ ! -d "portaudio" ]; then
    git clone https://github.com/PortAudio/portaudio.git
fi

cd portaudio

# Detect OS
OS=$(uname -s)
case $OS in
    Darwin)  # macOS
        # Create build directory
        mkdir -p build && cd build

        # Configure with CMake
        cmake .. -DCMAKE_BUILD_TYPE=Release \
            -DPA_BUILD_SHARED_LIBS=ON \
            -DBUILD_SHARED_LIBS=ON \
            -DPA_USE_COREAUDIO=ON

        # Build
        cmake --build .

        # Create bin directory and copy libraries
        mkdir -p ../bin
        cp libportaudio*.dylib ../bin/
        ;;

    Linux)
        # Install dependencies if needed
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y libasound2-dev libjack-jackd2-dev
        fi

        # Create build directory
        mkdir -p build && cd build

        # Configure with CMake
        cmake .. -DCMAKE_BUILD_TYPE=Release \
            -DBUILD_SHARED_LIBS=ON \
            -DPA_USE_ALSA=ON \
            -DPA_USE_JACK=ON

        # Build
        cmake --build .

        # Create bin directory and copy libraries
        mkdir -p ../bin
        cp libportaudio*.so* ../bin/
        ;;

    MINGW*|MSYS*|CYGWIN*)  # Windows
        # Create build directory
        mkdir -p build && cd build

        # Configure with CMake - enable shared libs and Windows APIs
        cmake .. -G "Visual Studio 17 2022" -A x64 \
            -DBUILD_SHARED_LIBS=ON \
            -DPA_USE_ASIO=0 \
            -DPA_USE_DS=1 \
            -DPA_USE_WASAPI=1 \
            -DPA_USE_WDMKS=1 \
            -DPA_USE_WMME=1

        # Build Release configuration
        cmake --build . --config Release

        # Create bin directory and copy libraries
        mkdir -p ../bin
        cp Release/portaudio.dll ../bin/
        cp Release/portaudio.lib ../bin/
        ;;

    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

cd ../.. 