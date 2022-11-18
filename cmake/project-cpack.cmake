#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#

# Allows to create a .deb package

set(CPACK_PACKAGE_EXECUTABLES ProjectName "ProjectName")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Example summary")

install(TARGETS ProjectName DESTINATION ${CPACK_INSTALL_PREFIX})

if(EXISTS ${BINARY_DIR}/lib)
  install(DIRECTORY "${BINARY_DIR}/lib/"
          DESTINATION "${CPACK_INSTALL_PREFIX}/lib/")
endif()

if(EXISTS ${BINARY_DIR}/assets)
  install(DIRECTORY "${BINARY_DIR}/assets/"
          DESTINATION "${CPACK_INSTALL_PREFIX}/assets/")
endif()

if(EXISTS ${BINARY_DIR}/scripts)
  install(DIRECTORY "${BINARY_DIR}/scripts/"
          DESTINATION "${CPACK_INSTALL_PREFIX}/scripts/")
endif()

if(EXISTS ${BINARY_DIR}/log)
  install(DIRECTORY "${BINARY_DIR}/log/"
          DESTINATION "${CPACK_INSTALL_PREFIX}/log/")
endif()

if(EXISTS ${BINARY_DIR}/configs)
  install(DIRECTORY "${BINARY_DIR}/configs/"
          DESTINATION "${CPACK_INSTALL_PREFIX}/configs/")
endif()

set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_VENDOR "Harvest Technology Group Pty Ltd")
# set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe.txt")
# set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "1")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_PACKAGE_INSTALL_DIRECTORY
    "CMake ${CMake_VERSION_MAJOR}.${CMake_VERSION_MINOR}")
set(CPACK_PACKAGE_CONTACT "developer@harvestinfinity.com")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Developer Name <${CPACK_PACKAGE_CONTACT}>")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://www.harvest.technology")

set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/icon.bmp")

if("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
  if(NOT $ENV{CI})
    set(CPACK_OUTPUT_FILE_PREFIX "${CMAKE_SOURCE_DIR}/packages")
  endif()

endif()

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  if("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "aarch64")
    set(CPACK_SYSTEM_NAME "arm64")
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "armv7l")
    set(CPACK_SYSTEM_NAME "armv7l")
  else()
    set(CPACK_SYSTEM_NAME "x86_64")
  endif()
endif()

# set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.3.1-6), libgcc1 (>= 1:3.4.2-12),
# python2.6, libboost-program-options1.40.0 (>= 1.40.0)")
# set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
# "${CMAKE_SOURCE_DIR}/name_of_python_app/postinst;${CMAKE_SOURCE_DIR}/name_of_python_app/prerm;")
# set(CPACK_PACKAGE_FILE_NAME
# "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}")

#[[
CPACK_PACKAGE_DESCRIPTION_FILE
CPACK_RESOURCE_FILE_WELCOME
CPACK_RESOURCE_FILE_LICENSE
CPACK_RESOURCE_FILE_README]]

set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
set(CPACK_STRIP_FILES "${BINARY_DIR}/${PROJECT_NAME}")
# set(CPACK_DEBIAN_PACKAGE_DEPENDS "libzip")

set(CPACK_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS
    OWNER_READ
    OWNER_WRITE
    OWNER_EXECUTE
    GROUP_READ
    GROUP_EXECUTE
    WORLD_READ
    WORLD_EXECUTE)

# Usage: cpack -G DEB Usage: cpack
include(CPack)
