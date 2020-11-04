## Installing Protobuf

### Windows
Run the `install.ps1` script (as an administrator). This will build libprotobuf and protoc, and place the resulting binaries, as well as the headers underneath the current (install) directory.

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