message("Building VkCPU CORE")

add_library(vkcpucore SHARED)

target_include_directories( vkcpucore
PRIVATE
    ${VKCPU_DIR}

)

target_link_libraries( vkcpucore
PRIVATE

)

target_sources( vkcpucore
PRIVATE
    VKCpu.cpp
)
