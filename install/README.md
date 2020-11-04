## Installing Protobuf

It's necessary to have libprotobuf available to link with when using protobuf in c++ projects. There is no officially released binaries for protobuf, and it is recommended to build from source and use the resulting binaries. This introduces a lot of overhead, as protobuf is not a small project to build, and it's preferable to have prebuilt binaries available. Both MacOS and Ubuntu provide prebuilt binaries 

### Windows
Run the `build.ps1` script (as an administrator). This will build libprotobuf and protoc, and place the resulting binaries and headers underneath the current (install) directory.

It will also set the `Protobuf_ROOT` environment variable to the current directory. This variable is used by CMake when trying to locate protobuf via `find_package(Protobuf REQUIRED)`.

### MacOS
The easiest way to install protobuf dev dependencies on mac is to just run
```sh
brew install protobuf
```

### Ubuntu
The easiest way to install protobuf (and protoc) dev dependencies on ubuntu is to run
```sh
sudo apt install -y libprotobuf-dev
sudo apt install -y protobuf-compiler
```