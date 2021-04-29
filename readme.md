# Visual Category Representations in the Infant Brain
This repository provides MATLAB example codes used in the study "Visual category representations in the infant brain (_"VCR_infant"_ in short)". 

On terminal, clone this repository to local:
```sh
git clone https://github.com/siyingxie/VCR_infant.git
```

## Demo codes
**IMPORTANT: To run the demo codes, a [LIBSVM] toolbox is required. Please see the "Dependency" and "Installation" sections for details.** 

Here are six examples corresponding to the six main analyses in the study.

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
_*Gabor filter model and VGG-19 deep neural network trained on object categorization_

## Dependency
The demo codes have the dependencies described below. You must download (or clone) these repositories and ensure that they are on your Matlab path.

| Resource/Software | Source/Identifier |
| ------ | ------ |
| Example data* | [https://osf.io/ruxfg] |
| LIBSVM toolbox♰ | [https://github.com/cjlin1/libsvm; RRID: SCR_010243] |

_* This item will be automatically downloaded to your path while running the demo codes (via ```setup.m```) if it has not already been downloaded._

_♰ This item needs to be downloaded and installed manually. (See "Installation" for details.)_

## Installation
Demo codes require [LIBSVM] (e.g., version-3.25) toolbox to run.
- On terminal, clone the [LIBSVM.git] repository to _/code_ directory.
    ```sh
    cd VCR_infant/code
    git clone https://github.com/cjlin1/libsvm.git
    ```
- If you are on Unix systems, you will need to compile the toolbox. Please rely on the steps in [LIBSVM.readme].
    <details><summary>A quick walk-through:</summary>
    <p>   

    - On MATLAB command window, type:
    ``` sh
    >> cd libsvm/matlab
    >> matlabroot % check your $MATLABROOT
    >> edit Makefile 
    ```
    - On MATLAB editor, manually edit the "Makefile":
    ```sh
    a) In line:3, change the "MATLABDIR ?= " to your $MATLABROOT 
    b) save the "Makefile"
    ```
    - Back on MATLAB command window, type:
    ``` sh
    >> make % it will take a few seconds to compile 
    ```
    _For more details, please see [LIBSVM.readme]._

    </p>
    </details>

## Required customized functions
These customized functions are provided in the repository. 

- averagetimepoints.m
- averagetrials.m
- correlatevectors.m
- covCor.m
- cvmvnn.m
- setup.m
- timefrexdecomp.m
- vectorizerdm.m

## Expected outputs 
The expected outputs from the example scripts (via MATLAB's publish) are available here.
- [example_decodingintime]
- [example_decodingtimefrequency]
- [example_decodingtimegeneralization]
- [example_rsatimegeneralization]
- [example_rsatimefrequency]
- [example_rsatomodels]

## Licenses
This content is licensed under a BSD 3-Clause License.

[//]: # (These are reference links used in the body of this note and they get stripped out when the markdown processor does its job. There is no need to format it nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [LIBSVM]: <https://www.csie.ntu.edu.tw/~cjlin/libsvm/>
   [LIBSVM.git]:  <https://github.com/cjlin1/libsvm/>
   [LIBSVM.readme]: <https://github.com/cjlin1/libsvm/blob/master/matlab/README>
   [example_decodingintime]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_decodingintime.html>
   [example_decodingtimefrequency]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_decodingtimefrequency.html>
   [example_decodingtimegeneralization]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_decodingtimegeneralization.html>
   [example_rsatimegeneralization]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_rsatimegeneralization.html>
   [example_rsatimefrequency]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_rsatimefrequency.html>
   [example_rsatomodels]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/example_rsatomodels.html>