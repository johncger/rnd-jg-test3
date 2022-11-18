# Add all libs from external projects to target
function(add_external_project_libs target_name)
   foreach (_projName IN LISTS HI_EXTERNAL_PROJECT_LIST)  
      message (STATUS "Add external project libs ${${_projName}_LIBRARIES}")
      target_link_libraries(${target_name} PRIVATE ${${_projName}_LIBRARIES})
   endforeach()
endfunction()