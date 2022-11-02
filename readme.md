# Visual Category Representations in the Infant Brain
This repository provides MATLAB example codes used in the study "Visual category representations in the infant brain (_"VCR_infant"_ in short)". 

You can clone this repository to local using:
```sh
git clone https://github.com/siyingxie/VCR_infant.git
```

## Example analyses
**IMPORTANT: To run the examples, a [LIBSVM] toolbox is required. Please see the "Dependency" and "Installation" sections for details.** 

Here are six examples analyses in the study.

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

| Resource/Software | Source/Identifier |
| ------ | ------ |
| Example data* | [https://osf.io/ruxfg] |
| LIBSVM toolbox♰ | [https://github.com/cjlin1/libsvm; RRID: SCR_010243] |

_* They will be automatically downloaded while running the examples (via ```setup.m```) if they have not already been downloaded._

_♰ The toolbox needs to be downloaded and installed manually. (See "Installation" for details.)_

## Installation
The examples require [LIBSVM] (e.g., version-3.25) toolbox, and please add the toolbox as follows:
- To clone the [LIBSVM.git] repository to the _/code_ directory, please use:
    ```sh
    cd VCR_infant/code
    git clone https://github.com/cjlin1/libsvm.git
    ```
- If you are on Unix systems, you will need to compile the toolbox. Please refer to the steps in [LIBSVM.readme].
    <details><summary>A quick walk-through:</summary>
    <p>   

    - On MATLAB command window, please type:
    ``` sh
    >> cd libsvm/matlab
    >> matlabroot % check your $MATLABROOT
    >> edit Makefile 
    ```
    - On MATLAB editor, please manually edit the "Makefile":
    ```sh
    a) In line:3, change the "MATLABDIR ?= " to your $MATLABROOT 
    b) save the "Makefile"
    ```
    - Back to the MATLAB command window, please type:
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

## Visualization
The expected outputs from the examples:
- [example_decodingintime]
- [example_decodingtimefrequency]
- [example_decodingtimegeneralization]
- [example_rsatimegeneralization]
- [example_rsatimefrequency]
- [example_rsatomodels]

Results for single participants:
- [singlesubject_decodingintime]
- [singlesubject_decodingtimegeneralization]
- [singlesubject_decodingtimefrequency]
- [singlesubject_rsatimegeneralization]
- [singlesubject_rsatimefrequency]

Model RDMs details:
- [visualise_modelRDMs]

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
   [singlesubject_decodingintime]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/singlesubject_decodingintime.html>
   [singlesubject_decodingtimegeneralization]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/singlesubject_decodingtimegeneralization.html>
   [singlesubject_decodingtimefrequency]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/singlesubject_decodingtimefrequency.html>
   [singlesubject_rsatimegeneralization]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/singlesubject_rsatimegeneralization.html>
   [singlesubject_rsatimefrequency]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/singlesubject_rsatimefrequency.html>
   [visualise_modelRDMs]: <http://htmlpreview.github.io/?https://github.com/siyingxie/VCR_infant/blob/main/code/html/visualise_modelRDMs.html>








