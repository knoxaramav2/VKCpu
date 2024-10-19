
build=false
run=""
test="DC_NO_TEST_CONTEXT"
local_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
clean=false
dumpProj=""
dumpFile=""
releaseType="Debug"
c_compiler="gcc"
cpp_compiler="g++"

version_opts='-DVK_MAJOR=0 -DVK_MAJOR_MAJOR=0 -DVK_BUILD_BUILD=0'

while getopts br:Tt:CD:d:Rx: flag
do 
    case "${flag}" in
        b) build=true;;
        r) run=${OPTARG};;
        t) test=${OPTARG};;
        T) test="";;
        C) clean=true;;
        D) dumpProj=${OPTARG};;
        d) dumpFile=${OPTARG};;
        R) releaseType="Release";;
        x) 
            if [ ${OPTARG} = "g++" ]; then 
                echo ">> G++"
                c_compiler="g++"
                cpp_compiler="g++"
            elif [ ${OPTARG} = "clang" ]; then
                echo ">> CLANG"
                c_compiler="clang"
                cpp_compiler="clang++"
            else
                c_compiler="gcc"
                cpp_compiler="g++"
                echo "Unrecognized compiler family '$OPTARG'. Defaulting to gcc/g++."
            fi
    esac
done

#echo "Build? " $build
#echo "Run? " $run
#echo "Test? " $test

if [ "$clean" = true ] ; then
    echo "Cleaning..."
    cmake --build ${local_path}/src --target clean
    rm -r ${local_path}/build
fi

if [ "$build" = true ] ; then
    echo "BUILD START"
    cmake -B "${local_path}/build" -S ${local_path}/src "${version_opts}" -DCMAKE_CXX_COMPILER="$cpp_compiler" -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_BUILD_TYPE="${releaseType}" \
        -DMAJOR_VRS=10 -DMINOR_VRS=5 -DBUILD_VRS=88
    cmake --build ${local_path}/build --config "${releaseType}"
    echo "DONE."
fi

if [ "$dumpProj" != "" ] ; then
    dumpDir="${local_path}/build/${dumpProj}/CMakeFiles/${dumpProj}.dir"
    files=""
    if [ "$dumpFile" = "" ] ; then
        files=$(find "$dumpDir" -type f -name "*.cpp.o")
    else
        files="${dumpDir}/${dumpFile}"
    fi

    for file in $files;
    do 
        echo "DUMP FILE: ${file}"
        if [ file = "" ]; then continue; fi
        set -x
        $(objdump -t "${file}")
    done
fi

if [ "$run" != "" ] ; then
    exec_dir="${local_path}/build/${run}/${run}"
    ${exec_dir}
fi

if [ "$test" != "DC_NO_TEST_CONTEXT" ] ; then
    if [ "$test" = "" ] ; then
        echo "Run all tests"

        cmake --build ./build/test
        ctest --test-dir "${local_path}/build" --output-on-failure --verbose
    else
        echo "Run test: ${test}"
        ctest "${local_path}/build"
    fi

fi



