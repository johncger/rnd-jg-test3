#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#
# Specify the sub directories to be part of the project
set(LIB_DIR_LIST src/libproj3)
foreach (_libDir IN LISTS LIB_DIR_LIST)
   message (STATUS "Add sub directory: ${_libDir}")
   add_subdirectory(${_libDir})
   # The following is to specify the libraries in the configuration file
   string(REPLACE "src/" ${PROJECT_NAME}:: LIB_NAME ${_libDir})
   # Add to a temporary list
   list(APPEND TEMP_PROJECT_LIB_LIST ${LIB_NAME})
endforeach()
message (STATUS "Project lib list: ${TEMP_PROJECT_LIB_LIST}")
set(PROJECT_LIB_LIST  ${TEMP_PROJECT_LIB_LIST} PARENT_SCOPE)