# Add an external Harvest project which is required for this project, most likely a library.
# project_name - The name of the external project.
# dependent_target_name - The name of the target which depends on the external project.
#
function(add_harvest_project ex_project_name dependent_target_name)
add_custom_target(${ex_project_name} ALL
                    COMMAND mkdir -p build
                    COMMAND cd build && cmake -DHIROOT=${HIROOT} ..
                    COMMAND cd build && make
                    COMMAND cd build && make install
                    WORKING_DIRECTORY ${HIROOT}/${ex_project_name}
                    COMMENT "Building ${ex_project_name}")
# specify the dependency
add_dependencies(${dependent_target_name} ${ex_project_name})
endfunction()