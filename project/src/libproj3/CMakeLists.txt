#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#
cmake_minimum_required(VERSION 3.21)
get_filename_component(PROJECT_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
# ##############################################################################
# Project flags
# ##############################################################################
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_STATIC_LIBRARY_PREFIX "")

# ##############################################################################
# Include directories
# ##############################################################################
# include_directories(include/external)
# include_directories(include/interface)
# include_directories(include/internal)

# ##############################################################################
# Source groups
# ##############################################################################
file(GLOB SOURCES "*.cpp")

# ##############################################################################
# Other CMake projects
# ##############################################################################
# add_subdirectory(lib-sub-project)

# ##############################################################################
# Target
# ##############################################################################
add_library(${PROJECT_LIB_NAME} STATIC ${SOURCES})

#export(TARGETS ${PROJECT_LIB_NAME} FILE exportFile.cmake)

# ##############################################################################
# External Harvest targets
# ##############################################################################

include(${CMAKE_SOURCE_DIR}/cmake/add-harvest-project.cmake)
foreach (EXT_PROJ IN LISTS HI_EXTERNAL_PROJECT_LIST)
   message(STATUS "Setting external project dependency: ${EXT_PROJ}")
   add_harvest_project(${EXT_PROJ} ${PROJECT_LIB_NAME})
endforeach()


# ##############################################################################
# Dependencies
# ##############################################################################

# target_link_libraries(${PROJECT_NAME} PUBLIC ExternalDependencyName)

target_include_directories(${PROJECT_LIB_NAME}
                           PUBLIC
                                  $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/project/include/interface>
                                  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
                           PRIVATE
                                  ${CMAKE_SOURCE_DIR}/project/include/internal 
                                  ${CMAKE_SOURCE_DIR}/project/include/external)


# Disable the <libname>_EXPORTS
set_target_properties(${PROJECT_LIB_NAME} PROPERTIES DEFINE_SYMBOL "")

# ##############################################################################
# External .so library linking for runtime The executable will look for
# libraries in the binary output directory under "lib" directory
# ##############################################################################
set_target_properties(${PROJECT_LIB_NAME} PROPERTIES LINK_FLAGS "-Wl,-rpath,./lib")
# For debug builds append _d to library name
set_target_properties(${PROJECT_LIB_NAME} PROPERTIES DEBUG_POSTFIX _d)

set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
set(CMAKE_INSTALL_RPATH "./lib")

# ##############################################################################
# Create a bundle in case you need to combine multiple static libraries
# ##############################################################################
#[[
include(../cmake/static-library-bundle.cmake)
if(WIN32)
  bundle_static_library(
    ${PROJECT_NAME} ${PROJECT_NAME}-${CMAKE_SYSTEM_PROCESSOR}
    "${CMAKE_CURRENT_SOURCE_DIR}${LIBRARY_DIR}/${CMAKE_BUILD_TYPE}/opus.lib")
  install(
    FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${CMAKE_SYSTEM_PROCESSOR}.lib
    DESTINATION "lib")
elseif(UNIX)
  bundle_static_library(
    ${PROJECT_NAME} ${PROJECT_NAME}-${CMAKE_SYSTEM_PROCESSOR}
    "${CMAKE_CURRENT_SOURCE_DIR}${LIBRARY_DIR}/libopus.a")
  install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${CMAKE_SYSTEM_PROCESSOR}.a
          DESTINATION "lib")
else()
  # Used by CI
  install(TARGETS ${PROJECT_NAME} DESTINATION "lib")
endif()
]]

# ##############################################################################
# Copy artifacts into the binary directory
# ##############################################################################
#[[add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMENT "Copying Bash scripts"
    COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/scripts
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}${SCRIPT_DIR}
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/scripts
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMENT "Copying sample log directory"
    COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/log
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/log
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/log
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMENT "Copying sample configs directory"
    COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/configs
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/configs
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/configs
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMENT "Copying sample assets directory"
    COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/assets
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/assets
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/assets
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMENT "Copying sample dependencies"
    COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/lib
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}${LIBRARY_DIR}/example.so.1.0.0
        ${CMAKE_CURRENT_SOURCE_DIR}${LIBRARY_DIR}/example.so
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/lib
)
]]

# ##############################################################################
# Copy the library to the install directory
#
# Note: Do not use it when static-library-bundle is enabled
# ##############################################################################
install(TARGETS ${PROJECT_LIB_NAME} EXPORT ${PROJECT_NAME})
# INstall the contents of the interface to install include location
install(DIRECTORY ${CMAKE_SOURCE_DIR}/project/include/interface/ DESTINATION ${CMAKE_SOURCE_DIR}/install/${CMAKE_INSTALL_INCLUDEDIR})
