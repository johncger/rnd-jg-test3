#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#

# ##############################################################################
# CMake cross-compilation flags, usage: -DCROSS_COMPILE=ANDROID.
#
# Available options: ANDROID, OS64, ARM64, NONE
# ##############################################################################
if("${CROSS_COMPILE}" STREQUAL "ANDROID")
  include(cmake/arm64-android24-toolchain.cmake)
elseif("${CROSS_COMPILE}" STREQUAL "OS64")
  set(PLATFORM "OS64")
  include(cmake/ios-toolchain.cmake)
elseif("${CROSS_COMPILE}" STREQUAL "ARM64")
  include(cmake/arm64-gcc-toolchain.cmake)
endif()
