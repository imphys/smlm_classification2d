# Software for Detecting Structural Heterogeneity in Single-Molecule Localization Microscopy Data. 

This software implements the a-priori knowledge-free unsupervised classification of structurally different particles, employing the Bhattacharya cost function as dissimilarity metrix. 

The main code is written in Matlab and the compute-intensive kernels have been written in CUDA and C++. The software in this directly is dependent on the submodule:  smlm_datafusion2d. For correct installation, please follow the instructions: https://github.com/imphys/smlm_datafusion2d 
