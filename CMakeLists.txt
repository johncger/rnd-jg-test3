#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#
cmake_minimum_required(VERSION 3.21.0)

include(cmake/cross-compile.cmake)
include(cmake/build-type.cmake)
include(cmake/hiroot.cmake)
# ##############################################################################
# Setup variables for the install locations
# ##############################################################################
# This creates variables for typical install locations bin,include and lib
set(CMAKE_PREFIX_PATH ${HIROOT}/HILib)
set(CMAKE_INSTALL_PREFIX ${HIROOT}/HILib)
include(GNUInstallDirs)

# ##############################################################################
# Set the projects name
# ##############################################################################
project(
  rnd-jg-test3
  VERSION 0.1.0
  LANGUAGES CXX)

# ##############################################################################
# CMake build flags
# ##############################################################################

include (cmake/cxx-properties.cmake)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
include (cmake/project-properties.cmake)
# ##############################################################################
# Harvest projects this depends upon, empty list means none
# ##############################################################################
set(HI_EXTERNAL_PROJECT_LIST rnd-jg-test2)
foreach (EXT_PROJ IN LISTS HI_EXTERNAL_PROJECT_LIST)
   message(STATUS "Finding project: ${EXT_PROJ}")
   find_package(${EXT_PROJ} QUIET)
   if (NOT ${${EXT_PROJ}_FOUND})
      message(WARNING "Project ${EXT_PROJ} not found. Will be made an external project.")
      list (APPEND SUPER_BUILD_PROJECTS ${EXT_PROJ})
   else()
      message(STATUS "${EXT_PROJ} found")
   endif()
endforeach()
if (SUPER_BUILD_PROJECTS)
   include (super-build)
   return()
endif()

# ##############################################################################
# Bundle requirement for Apple builds
# ##############################################################################
if(APPLE)
  set_target_properties(
    ${APP_NAME}
    PROPERTIES BUNDLE True
               MACOSX_BUNDLE_GUI_IDENTIFIER ${PROJECT_NAME}
               MACOSX_BUNDLE_BUNDLE_NAME ${PROJECT_NAME}
               MACOSX_BUNDLE_BUNDLE_VERSION "0.1"
               MACOSX_BUNDLE_SHORT_VERSION_STRING "0.1")
endif()

# ##############################################################################
# Locations of binaries, libraries and scripts
# ##############################################################################
include(cmake/determine-locations.cmake)

# ##############################################################################
# Main project directory
# ##############################################################################
add_subdirectory(project)

# ##############################################################################
# Configure project file for use by find_package so this project can be used by other projects
# ##############################################################################
# configure_file(${CMAKE_SOURCE_DIR}/proj1Config-template.cmake ${CMAKE_SOURCE_DIR}/proj1Config.cmake)

# link_directories(${CMAKE_SOURCE_DIR}${LIBRARY_DIR})

# ##############################################################################
# Linting and formatting
# ##############################################################################
# Allows to perform linting and formatting, uses ${LINT_SOURCES},
# include/internal, include/interface, compile_commands.json,
# ${CMAKE_SOURCE_DIR}, ${CMAKE_BINARY_DIR} set(EXCLUDE_DIRECTORIES
# "./project/include/external,./build")
include(cmake/linter.cmake)

# ##############################################################################
# Documentation
# ##############################################################################
# Usage: make doc
option(BUILD_DOCUMENTATION "Build the documentation" ON)

# ##############################################################################
# Testing
# ##############################################################################
option(BUILD_TESTS "Build the tests" ON)
if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(test)
endif()

# ##############################################################################
# Install - Used by CI
# ##############################################################################
# Targets are first installed to an export set with the name of the project. One
# export set for the entire project.
# target ProjectConfiguration defined in cxx-properties.cmake
install(TARGETS ProjectConfiguration
        EXPORT ${PROJECT_NAME})

# Install the entire package
set(_cmakeDestinationDir ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})
install(EXPORT ${PROJECT_NAME} 
        DESTINATION ${_cmakeDestinationDir}
        NAMESPACE "${PROJECT_NAME}::")

# Create the package configuration file
include(CMakePackageConfigHelpers)

set(_packageConfigFile ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake)
# PROJECT_LIB_LIST is set in the project CMakeLIsts.txt
configure_package_config_file(
  cmake/${PROJECT_NAME}Config.cmake.template
  ${_packageConfigFile}
  PATH_VARS CMAKE_INSTALL_INCLUDEDIR
  INSTALL_DESTINATION ${_cmakeDestinationDir}
)
install(FILES ${_packageConfigFile}
        DESTINATION ${_cmakeDestinationDir})
unset(_packageConfigFile)

# Create a package version file
set(_packageConfigVersionFile "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake")
write_basic_package_version_file(
  ${_packageConfigVersionFile}
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)
install(FILES ${_packageConfigVersionFile}
        DESTINATION ${_cmakeDestinationDir})
unset(_packageConfigVersionFile)
unset(_cmakeDestinationDir)
# ##############################################################################
# Debian Packaging
# ##############################################################################

# Usage: cpack -G DEB Usage: cpack Allows to create a .deb package
# include(cmake/project-cpack.cmake)
