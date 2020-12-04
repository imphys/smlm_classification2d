# Software for Detecting Structural Heterogeneity in Single-Molecule Localization Microscopy Data. 

This software implements the a-priori knowledge-free unsupervised classification of structurally different particles, employing the Bhattacharya cost function as dissimilarity metrix. 

The main code is written in Matlab and the compute-intensive kernels have been written in CUDA and C++. The software in this directory is dependent on the submodule:  smlm_datafusion2d. For correct installation, please follow the instructions: https://github.com/imphys/smlm_datafusion2d 

Please follow the instructions in the demo file (**demo_classification.m**) using the respective data in the data-folder. 



## Installation on Linux

Use the following commands to build the necessary libraries for this software:

```bash

cmake .
make
make install
````

CMake locates the code's dependencies and generates a Makefile. Make compiles the mex files and necessary shared libraries. Make install copies the mex files to the right directory for use in Matlab, it does not require priviledges to run.

## Installation on Windows

Make sure you have all dependencies downloaded and installed. In particular make sure that your CUDA version and MS Visual Studio version are 
compatible. Use the following commands to build the necessary libraries for this software:

```bash

mkdir build
cd build
cmake -G "Visual Studio 14 2015 Win64" -DCUB_INCLUDE_DIR="C:\path_to_your_cub_dir\cub" ..
cd ..
python fix_msbuild_files.py

````

Then open MS Visual Studio, for example by double clicking on ALL_BUILD.vcxproj and build all the targets.
It could be that you manually need to build the targets expdist and gausstransform before building the 
other targets.

Then, copy all the .mexw64 files from build/Debug/ to the MATLAB/all2all directory.



### Installation instructions for CPU-only Version

If you do not have a CUDA capable GPU you could install the software without GPU acceleration. Do note that the code will be orders of magnitude slower. Use the following commands to install the CPU-only version:
```bash

cmake -DUSE_GPU=OFF .
make
make install
```