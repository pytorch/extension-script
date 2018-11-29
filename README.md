# Custom TorchScript Operators Example

This repository contains examples for writing, compiling and using custom
TorchScript operators. See [here]() for the accompanying tutorial.

## Contents

There a few monuments in this repository you can visit. They are described in
context in the tutorial, which you are encouraged to read. These monuments are:

- `example_app/warp_perspective/op.cpp`: The custom operator implementation,
- `example_app/main.cpp`: An example application that loads and executes a serialized TorchScript model, which uses the custom operator, in C++,
- `script.py`: Example of using the custom operator in a scripted model,
- `trace.py`: Example of using the custom operator in a traced model,
- `eager.py`: Example of using the custom operator in vanilla eager PyTorch,
- `load.py`: Example of using `torch.utils.cpp_extension.load` to build the custom operator,
- `load.py`: Example of using `torch.utils.cpp_extension.load_inline` to build the custom operator,
- `setup.py`: Example of using setuptools to build the custom operator,
- `test_setup.py`: Example of using the custom operator built using `setup.py`.

To execute the C++ application, first run `script.py` to serialize a TorchScript
model to a file called `example.pt`, then pass that file to the
`example_app/build/example_app` binary.

## Setup

For the smoothest experience when trying out these examples, we recommend
building a docker container from this repository's `Dockerfile`. This will give
you a clean, isolated Ubuntu Linux environment in which we guarantee everything
to work perfectly. These steps should get you started:

```sh
$ git clone https://github.com/pytorch/extension-script

$ cd extension-script

$ docker build -t extension-script .

$ docker run -v $PWD:/home -it extension-script

$ root@2f00feefe46a:/home# source /activate # Activate the Conda environment

$ cd example_app && mkdir build && cd build

$ cmake -DCMAKE_PREFIX_PATH=/libtorch ..
-- The C compiler identification is GNU 5.4.0
-- The CXX compiler identification is GNU 5.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Looking for pthread.h
-- Looking for pthread.h - found
-- Looking for pthread_create
-- Looking for pthread_create - not found
-- Looking for pthread_create in pthreads
-- Looking for pthread_create in pthreads - not found
-- Looking for pthread_create in pthread
-- Looking for pthread_create in pthread - found
-- Found Threads: TRUE
-- Found torch: /libtorch/lib/libtorch.so
-- Configuring done
-- Generating done
-- Build files have been written to: /home/example_app/build

$ make -j
Scanning dependencies of target warp_perspective
[ 25%] Building CXX object warp_perspective/CMakeFiles/warp_perspective.dir/op.cpp.o
[ 50%] Linking CXX shared library libwarp_perspective.so
[ 50%] Built target warp_perspective
Scanning dependencies of target example_app
[ 75%] Building CXX object CMakeFiles/example_app.dir/main.cpp.o
[100%] Linking CXX executable example_app
[100%] Built target example_app
```

This will create a shared library under
`/home/example_app/build/warp_perspective/libwarp_perspective.so` containing the
custom operator defined in `example_app/warp_perspective/op.cpp`. Then, you can
run the examples, e.g.:

```sh
(base) root@2f00feefe46a:/home# python script.py
graph(%x.1 : Dynamic
      %y : Dynamic) {
  %20 : int = prim::Constant[value=1]()
  %16 : int[] = prim::Constant[value=[0, -1]]()
  %14 : int = prim::Constant[value=6]()
  %2 : int = prim::Constant[value=0]()
  %7 : int = prim::Constant[value=42]()
  %z.1 : int = prim::Constant[value=5]()
  %z.2 : int = prim::Constant[value=10]()
  %13 : int = prim::Constant[value=3]()
  %4 : Dynamic = aten::select(%x.1, %2, %2)
  %6 : Dynamic = aten::select(%4, %2, %2)
  %8 : Dynamic = aten::eq(%6, %7)
  %9 : bool = prim::TensorToBool(%8)
  %z : int = prim::If(%9)
    block0() {
      -> (%z.1)
    }
    block1() {
      -> (%z.2)
    }
  %17 : Dynamic = aten::eye(%13, %14, %2, %16)
  %x : Dynamic = my_ops::warp_perspective(%x.1, %17)
  %19 : Dynamic = aten::matmul(%x, %y)
  %21 : Dynamic = aten::add(%19, %z, %20)
  return (%21);
}

tensor([[11.6196, 12.0056, 11.6122, 12.9298,  7.0649],
        [ 8.5063,  9.0621,  9.9925,  6.3741,  8.9668],
        [12.5898,  6.5872,  8.1511, 10.0806, 11.9829],
        [ 4.9142, 11.6614, 15.7161, 17.0538, 11.7243],
        [10.0000, 10.0000, 10.0000, 10.0000, 10.0000],
        [10.0000, 10.0000, 10.0000, 10.0000, 10.0000],
        [10.0000, 10.0000, 10.0000, 10.0000, 10.0000],
        [10.0000, 10.0000, 10.0000, 10.0000, 10.0000]])
```
