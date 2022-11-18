# Add All specified project libs to the specified target
function(add_project_libs target_name)
   foreach (_libName IN LISTS PROJECT_LIB_LIST)  
      # The following is to specify the libraries in the configuration file
      string(REPLACE ${PROJECT_NAME}:: "" LIB_NAME ${_libName})
      message (STATUS "Add lib: ${LIB_NAME}")
      target_link_libraries(${target_name} PRIVATE ${LIB_NAME})
   endforeach()
endfunction()