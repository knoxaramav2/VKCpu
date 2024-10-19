message("Building Tests")

add_executable(vkcpu_tests)

target_include_directories(vkcpu_tests
    PRIVATE

)

target_link_libraries(vkcpu_tests
PRIVATE

)

add_test(NAME TestGroup COMMAND vkcpu_tests)
set(TEST_SRC "${CMAKE_BINARY_DIR}/bin/scripts")
add_compile_definitions(TEST_SRC="${DCLANG_DEV_SRC}/test")

target_sources(vkcpu_tests
PRIVATE
    tests.cpp
)
