#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  if("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "aarch64"
     OR "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm64")
    set(BINARY_DIR ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME}/arm64)
    set(LIBRARY_DIR /lib/arm64/linux)
    set(SCRIPT_DIR /scripts/arm64/linux)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "armv7l")
    set(BINARY_DIR ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME}/armv7l)
    set(LIBRARY_DIR /lib/armv7l/linux)
    set(SCRIPT_DIR /scripts/armv7l/linux)
  else()
    set(BINARY_DIR ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME}/x86_64)
    set(LIBRARY_DIR /lib/x86_64/linux)
    set(SCRIPT_DIR /scripts/x86_64/linux)
  endif()
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  set(BINARY_DIR ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME})
  set(LIBRARY_DIR /lib/x86_64/win)
  set(SCRIPT_DIR /scripts/x86_64/win)
  set(CMAKE_INSTALL_PREFIX
      ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Android")
  set(BINARY_DIR ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME})
  set(LIBRARY_DIR /lib/arm64/android)
  set(SCRIPT_DIR /scripts/arm64/android)
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "iOS")
  set(BINARY_DIR ${CMAKE_BINARY_DIR}/bin/${CMAKE_SYSTEM_NAME})
  set(LIBRARY_DIR /lib/arm64/ios)
  set(SCRIPT_DIR /scripts/arm64/ios)
endif()
# Executable location
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BINARY_DIR})
# Shared library location
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}${LIBRARY_DIR})
# Static library location
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}${LIBRARY_DIR})

message (STATUS "Executable output directory: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message (STATUS "Shared library output directory: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
message (STATUS "Static library output directory: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
