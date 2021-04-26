# Visual Category Representations in the Infant Brain
This repository provides MATLAB example codes used in the study "Visual category representations in the infant brain (_"VCR_infant"_ in short)". 

To clone this repository to local, please use:
```sh
git clone https://github.com/siyingxie/VCR_infant.git
```
## Demo codes
IMPORTANT: To run the demo codes, a [LIBSVM] toolbox is required. Please see the "Dependency" and "Installation" sections for details. 

- Decode object categories in time (runtime: ~ 2 min) 
    ```sh
    example_decodingintime.m
    ```
- Decode object categories in time and frequency (runtime: ~ 5 min) 
    ```sh
    example_decodingtimefrequency.m
    ```
- Time generalization analysis (runtime: ~ 1 min) 
    ```sh
    example_decodingtimegeneralization.m 
    ```
- Relate category representations in infants and adults (runtime: ~ 1 min) 
    ```sh
    example_rsatimegeneralization.m 
    ```
- Relate oscillation-based category representations in infants and adults (runtime: ~ 1 min) 
    ```sh
    example_rsatimefrequency.m
    ```
- Relate category representations to computational models* (runtime: ~ 1 min) 
    ```sh
    example_rsatomodels.m
    ```
_*Gabor filter model and the VGG-19 deep neural network trained on object categorization._

## Dependency
The demo codes have the following dependencies. You must download (or clone) these repositories and ensure that they are on your path.

| Resource/Software | Source/Identifier |
| ------ | ------ |
| Example data* | [https://osf.io/ruxfg] |
| LIBSVM toolbox♰ | [https://github.com/cjlin1/libsvm; RRID: SCR_010243] |
| MatConvNet Toolbox☨ | [https://github.com/vlfeat/matconvnet] |

_* This item will be automatically downloaded to your path if it has not already been downloaded._

_♰ This item needs to download and install manually. (See "Installation" for details.)_

_☨ This item is not required for running the demo codes._

## Required customized functions
- averagetimepoints.m
- averagetrials.m
- correlatevectors.m
- covCor.m
- cvmvnn.m
- setup.m
- timefrexdecomp.m
- vectorizerdm.m

## Installation
Demo codes require [LIBSVM] (e.g., version-3.25) toolbox to run.
- Clone the [LIBSVM.git] repository to _/code_ directory.
    ```sh
    cd VCR_infant/code
    git clone https://github.com/cjlin1/libsvm.git
    ```
- If you are on Unix systems, you need to create the corresponding mex files. Please rely on the following steps.

    > We recommend using make.m on both MATLAB and OCTAVE. Just type 'make'
    to build 'libsvmread.mex', 'libsvmwrite.mex', 'svmtrain.mex', and
    'svmpredict.mex'.
    > On MATLAB or Octave:
    >     >> make
    
    > If make.m does not work on MATLAB (especially for Windows), try 'mex
    -setup' to choose a suitable compiler for mex. Make sure your compiler
    is accessible and workable. Then type 'make' to do the installation.
    > Example:
    >  matlab>> mex -setup
    
    > MATLAB will choose the default compiler. If you have multiple compilers,
    a list is given and you can choose one from the list. For more details,
    please check the following page:
    > https://www.mathworks.com/help/matlab/matlab_external/choose-c-or-c-compilers.html
    
    > On Unix systems, if neither make.m nor 'mex -setup' works, please use
    Makefile and type 'make' in a command window. Note that we assume
    your MATLAB is installed in '/usr/local/matlab'. If not, please change
    MATLABDIR in Makefile.
    
    _Quoted from [LIBSVM.readme]._

## Expected outputs 
The outputs from the example scripts (via MATLAB's publish) are available here.
- [exmaple_decodoingintime]
- [example_decodingtimefrequency]
- [example_decodingtimegeneralization]
- [example_rsatimegeneralization]
- [example_rsatimefrequency]
- [example_rsatomodels]

## Licenses
This content is licensed under a BSD 3-Clause License.

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format it nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [LIBSVM]: <https://www.csie.ntu.edu.tw/~cjlin/libsvm/>
   [LIBSVM.git]:  <https://github.com/cjlin1/libsvm/>
   [LIBSVM.readme]: <https://github.com/cjlin1/libsvm/blob/master/matlab/README>
   [exmaple_decodoingintime]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_decodingintime.html>
   [example_decodingtimefrequency]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_decodingtimefrequency.html>
   [example_decodingtimegeneralization]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_decodingtimegeneralization.html>
   [example_rsatimegeneralization]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_rsatimegeneralization.html>
   [example_rsatimefrequency]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_rsatimefrequency.html>
   [example_rsatomodels]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_rsatomodels.html>