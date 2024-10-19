message("Building VkCPU")

cmake_minimum_required(VERSION 3.28)
project(VKCpu)

#Version config
if(NOT DEFINED MAJOR_VRS) 
    set(MAJOR_VRS 0) 
endif()
if(NOT DEFINED MINOR_VRS) 
    set(MINOR_VRS 0) 
endif()
if(NOT DEFINED BUILD_VRS) 
    set(BUILD_VRS 0) 
endif() 

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin/debug)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin/release)

# Set the output directories for different types of targets
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/lib)

set(ROOTDIR ${CMAKE_CURRENT_SOURCE_DIR}/build)

message("Build Version: ${MAJOR_VRS}.${MINOR_VRS}.${BUILD_VRS}")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)


set(VKCPU_DIR ${CMAKE_CURRENT_SOURCE_DIR}/VCpuDir)
set(TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR}/test)


add_subdirectory(VCpuCore)


#Testing
enable_testing()
add_subdirectory(test)

