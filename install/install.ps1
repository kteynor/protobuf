# build protobuf library for c++, and configure system so
# cmake find_package(Protobuf) will resolve to the built dir

param(
    [Parameter(Mandatory=$false)]
    [switch]$Clean=$false
)

$install_dir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$build_dir = "$install_dir\..\cmake\build"
$cmake_dir = "$install_dir\..\cmake"

if ($Clean) {
    # clear install dir contents
    Write-Host "Cleaning install directory ($install_dir)"
    if (Test-Path "$install_dir\bin") { Remove-Item "$install_dir\bin" -Recurse }
    if (Test-Path "$install_dir\cmake") { Remove-Item "$install_dir\cmake" -Recurse }
    if (Test-Path "$install_dir\include") { Remove-Item "$install_dir\include" -Recurse }
    if (Test-Path "$install_dir\lib") { Remove-Item "$install_dir\lib" -Recurse }

    # clear build dir contents
    Write-Host "Cleaning build directory ($build_dir)"
    Get-ChildItem -Path "$build_dir" | ForEach-Object { Remove-Item $_.FullName -Recurse }
}

# generate cmake build files for cmake subdir, in a nested
# cmake/build directory, and configure the current dir as 
# the install prefix path
cmake -S "$cmake_dir" -B "$build_dir" -DCMAKE_INSTALL_PREFIX="$install_dir" -DCMAKE_CXX_STANDARD=17 -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_MSVC_STATIC_RUNTIME=FALSE -Dprotobuf_UNICODE=ON

# build the install target in debug and release
cmake --build "$build_dir" --config Debug --target install
cmake --build "$build_dir" --config Release --target install

$proto_root_env_name="Protobuf_ROOT"
$proto_root = [System.Environment]::GetEnvironmentVariable($proto_root_env_name, [System.EnvironmentVariableTarget]::Machine)

# check if environment variable for install location needs to be set
if ($proto_root -eq $install_dir) {
    Write-Host("Environment variable '$proto_root_env_name' is correctly configured: '$install_dir'")
} else {
    try {
        # set update env variable for the protobuf install location
        # so cmake can find the build output from find_package(Protobuf)
        [System.Environment]::SetEnvironmentVariable($proto_root_env_name, $install_dir, [System.EnvironmentVariableTarget]::Machine)
        Write-Host("Environment variable '$proto_root_env_name' is now configured: '$install_dir'")
    } catch [System.Management.Automation.MethodInvocationException] {
        # catch this exception which will be thrown if called without
        # admin rights, and warn caller they may need to manually set
        # the environment variable
        Write-Host("")
        Write-Host("Unable to set Protobuf_ROOT environment variable, cmake may be unable to automatically locate the protobuf install.") -ForegroundColor Yellow
        Write-Host("Make sure the environment variable '$proto_root_env_name' is set to '$install_dir'.") -ForegroundColor Yellow
        Write-Host("")
    }
}
