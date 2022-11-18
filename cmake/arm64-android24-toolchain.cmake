#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#

# Allows compiling outside of Android Studio.
#
# Before using the cmake file, please add ANDROID_NDK_HOME to environment
# variables. Tested on Windows only

set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(ANDROID_PLATFORM android-24)
set(ANDROID_ABI arm64-v8a)
#[[ cmake command example: cmake ..  -DCMAKE_MAKE_PROGRAM=ninja -G Ninja -DCMAKE_BUILD_TYPE=Release -DANDROID_PLATFORM=android-24 -D ANDROID_ABI=arm64-v8a ]]

if(NOT DEFINED ENV{ANDROID_NDK_HOME})
  message(FATAL_ERROR "Please set ANDROID_NDK_HOME env variable.")
endif()

set(CMAKE_TOOLCHAIN_DIRECTORY "$ENV{ANDROID_NDK_HOME}/build/cmake")
set(ANDROID_STL c++_shared)
if(NOT CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE
      "${CMAKE_TOOLCHAIN_DIRECTORY}/android.toolchain.cmake")
endif()

if(WIN32 AND NOT CMAKE_MAKE_PROGRAM)
  set(CMAKE_MAKE_PROGRAM
      "$ENV{ANDROID_NDK_HOME}/prebuilt/windows-x86_64/bin/make.exe"
      CACHE INTERNAL "" FORCE)
elseif(LINUX AND NOT CMAKE_MAKE_PROGRAM)
  set(CMAKE_MAKE_PROGRAM
      "$ENV{ANDROID_NDK_HOME}/prebuilt/linux-x86_64/bin/make"
      CACHE INTERNAL "" FORCE)
endif()
