param (
    [switch]$b,
    [string]$run,
    #[string]$test = "NO_TEST_CONTEXT",
    [switch]$test,
    [switch]$clean,
    [string]$dumpProj,
    [string]$dumpFile,
    [string]$releaseType = "Debug",
    [string]$compiler = "g++",
    [switch]$h
)

$local_path = "${pwd}"#Split-Path -Parent $MyInvocation.MyCommand.Path
$c_compiler = "gcc"
$cpp_compiler = "g++"

if($h){
    Write-Host "-b                              Build"
    Write-Host "-run <program>                  Execute Program"
    Write-Host "-test <Test Name>?              Specify test"
    Write-Host "-clean                          Clean build artifacts"
    Write-Host "-dumpProj                       "
    Write-Host "-dumpFile                       "
    Write-Host "-releaseType <Debug/Release>    "
    Write-Host "-compiler <compiler>            "
    Write-Host "-h                              This dialog"

    BREAK
}

if($b){
    switch ($compiler) {
        "g++" {
            #Write-Host ">> G++"
            $c_compiler = "gcc"
            $cpp_compiler = "g++"
        }
        "clang" {
            #Write-Host ">> CLANG"
            $c_compiler = "clang"
            $cpp_compiler = "clang++"
        }
        default {
            throw "Unrecognized compiler. Specify g++ (default) or clang"
        }
    }
}

if ($clean) {
    Write-Host "Cleaning..."
    cmake --build "$local_path/src" --target clean
    rm "CMakeCache.txt" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "$local_path/build" -ErrorAction SilentlyContinue
}

if ($b) {
    Write-Host "BUILD START ($releaseType)"
    cmake -B "$local_path/build" -S "$local_path/src" -DCMAKE_CXX_COMPILER="$cpp_compiler" -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_BUILD_TYPE="$releaseType" `
        -DMAJOR_VRS=10 -DMINOR_VRS=5 -DBUILD_VRS=88
    cmake --build "$local_path/build" --config "$releaseType"
    Write-Host "DONE."
}

if ($dumpProj) {
    $dumpDir = "$local_path/build/$dumpProj/CMakeFiles/$dumpProj.dir"
    $files = if ($dumpFile) { "$dumpDir/$dumpFile" } else { Get-ChildItem -Path $dumpDir -Recurse -Filter "*.cpp.o" }

    foreach ($file in $files) {
        Write-Host "DUMP FILE: $file"
        if ($file) {
            & objdump -t $file
        }
    }
}

if ($run) {
    Write-Host "RUN $run"
    # $exec_dir = "$local_path/build/$run/$releaseType/$run"
    $exec_dir = "$local_path/build/bin/$releaseType/$run"
    & $exec_dir
}

#if ($test -ne "NO_TEST_CONTEXT") {
if ($test) {
    Write-Host "Run all tests"
    cmake --build ./build/test
    ctest --test-dir "$local_path/build/bin/$releaseType/" --output-on-failure --verbose
    # if (-not $test) {
    #     Write-Host "Run all tests"
    #     cmake --build ./build/test
    #     ctest --test-dir "$local_path/build/bin/$releaseType/vkcpu_tests.exe" --output-on-failure --verbose
    # } else {
    #     Write-Host "Run test: $test"
    #     ctest "$local_path/build/bin/$releaseType/$test"
    # }
}
