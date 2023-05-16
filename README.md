# CXR-Lung-Risk

Deep learning to estimate lung-related mortality from chest radiographs. This work was published in [Nature Communications](https://www.nature.com/articles/s41467-023-37758-5), and is open access!

If you use code or parts of this code in your work, please cite our publication and/or the Zenodo supplement:

> Weiss, J., Raghu, V.K., Bontempi, D. et al. Deep learning to estimate lung disease mortality from chest radiographs. Nat Commun 14, 2797 (2023). https://doi.org/10.1038/s41467-023-37758-5

> Weiss, Jakob, Raghu, Vineet, Bontempi, Dennis, Christiani, David, Mak, Raymond, Lu, Michael T., & Aerts, Hugo. (2023). Deep learning to estimate lung disease mortality from chest radiographs. In Nature Communications (1.0.0). Zenodo. https://doi.org/10.5281/zenodo.7941660

The supporting material, including the sample data and the pre-trained Deep Learning models used in [the MWE notebook](https://github.com/AIM-Harvard/CXR-Lung-Risk/blob/main/notebooks/cxr_lung_risk_mwe.ipynb), can be found at [Zenodo project page](https://zenodo.org/record/7941660#.ZGOiqOxBzdp).

# Table of Contents

- [Overview](#overview)
- [Installation and Usage](#installation-and-usage)
  - [Cloud-based Working Instance](#cloud-based-working-instance)
  - [MHubAI model](#mhubai-model)
  - [Local Set-up](#local-set-up)
    - [System Pre-requisites](#system-pre-requisites)
    - [Model Weights](#model-weights)
    - [Image Pre-processing](#image-pre-processing)
    - [Running the Inference](#running-the-inference)
- [Data](#data)
- [Acknowledgments](#acknowledgments)

# Overview

Prevention and management of chronic lung diseases (COPD, lung cancer, etc.) are of great importance. Predicting who will develop severe morbidity and mortality and thus could benefit most from prevention is challenging. Therefore, new possibilities to improve risk stratification are desirable. Chest radiographs (CXR) are common in patients at risk for chronic lung disease and may provide a window into long-term risk. Here, we developed and tested a deep learning model, CXR Lung-Risk, predicting the risk of lung-related mortality from a routine CXR image.

Chest x-rays (radiographs or CXRs) are among the most common diagnostic imaging tests in medicine. We hypothesized that a convolutional neural network (CNN) could extract information from these x-rays to estimate a person's risk of lung-related mortality within 18 years (called CXR-Lung-Risk) - a summary measure of overall lung health based on the chest x-ray image. We tested whether CXR-Lung-Risk predicted lung disease beyond established risk factors.

CXR-Lung-Risk outputs a number (in years) reflecting lung-related mortality risk based on only a single chest radiograph image. CXR-Lung-Risk was trained in >40k persons from the Prostate, Lung, Colorectal and Ovarian cancer screening trial (PLCO), a randomized controlled trial of chest x-ray to screen healthy persons for lung cancer. 

CXR-Lung-Risk was tested (referred to as "validation" in the publication) in an independent cohort of 10.5k individuals from PLCO and externally tested in 5.5k heavy smokers from the National Lung Screening Trial (NLST) and 1k patients in the Boston Lung Cancer Study. CXR-Lung-Risk predicted lung-related mortality beyond risk factors in all three cohorts. 

**Central Illustration of CXR-Age**
![CXR-Age Central Illustration](/assets/central_illustration.png)

This repository contains data intended to promote reproducible research. It is not for clinical care or commercial use. 

# Installation and Usage

We provide three different ways of running our cxr-lung-risk model:
- A cloud-based and free-to-use example of the end-to-end pipeline, suitable for users with minimal coding proficiency that are interested in a thorough description of all the steps of the processing and do not want to install any software on their local node;
- A dockerized version of the pipeline, including a standardized interface to interact with, suitable for users without coding proficiency that want to process data on a local node;
- The source code, complete with a working Conda environment, is suitable for users with minimal coding proficiency that want to process data on a local node.

## Cloud-based Working Instance

To showcase how our model works, promote transparency, and encourage further validation of our deep learning solution, we provide the community with a free-to-use working implementation of the end-to-end pipeline through a Google Colab Notebook.

The cloud-based instance allows users with minimal coding proficiency to process a large amount of CXR data without having to install anything on their local node. In the notebook, we describe all the preprocessing steps needed to convert a standard of care CXR from the DICOM format to the format the ensemble model accepts as an input - using a small sample from [Kaggle's UNIFESP X-ray Body Part Classifier Competition dataset](https://www.kaggle.com/competitions/unifesp-x-ray-body-part-classifier) as an example. We also describe thoroughly all the steps of the processing, discuss the different models composing the ensemble and their details, and provide an output sample.

The Colab notebook can be accessed by clicking on the badge below.

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/AIM-Harvard/CXR-Lung-Risk/blob/main/notebooks/cxr_lung_risk_mwe.ipynb)

## MHubAI model

To make the pipeline easy to run and deploy, we are currently in the process of adding the CXR-Lung model to the collection of models in MHub.ai.

To learn more about the MHub.ai initiative and the models hosted, you can visit the [MHub.ai website](https://mhub.ai)

## Local Set-up

This repository stores the source code the user can use to run the pipeline on a local node, complete with a working Conda environment. The source code can be found under `src/`. In this case, the user will need to take care of the model download, system and conda environment set-up, and data pre-processing.

### System Pre-requisites

The following code was tested on `Ubuntu 20.04.1`, `conda 22.9.0`, `python 3.8`, `fastai 2.7.9`, `cuda 11.5.1`, `torch 1.13` and `pretrainedmodels 0.7.4`. The full list of dependencies needed to set up an identical environment can be found in `cxr-lung-risk.yaml`. The conda environment(s) can be installed, once in the repository folder, by running:

```
conda env create --file cxr-lung-risk-gpu.yaml 
```
for the GPU-enabled environment, and

```
conda env create --file cxr-lung-risk-nogpu.yaml 
```
for the CPU inference. The set-up of one of the environments on a normal Desktop PC should take at most a couple of minutes.

Inference can be run on the GPU or CPU and should work with around 4GB of GPU VRAM or CPU RAM. For GPU inference, a CUDA 11-capable GPU is required. Inference times per patient can greatly vary depending on the CPU and/or the GPU the system is equipped with - as well as a number of other factors (e.g., the system I/O speed and how many subjects need to be processed). In general, running the inference pipeline on one patient should not take more than a few seconds.

### Model Weights

Model weights are available from the following shared location: <add-link>

### Image Pre-processing
PLCO radiographs were provided as scanned TIF files by the NCI. TIFs were converted to PNGs with a minimum dimension of 512 pixels with ImageMagick v6.8.9-9. Image preprocessing was performed as described at https://github.com/michaeltlu/cxr-risk 

Many of the PLCO radiographs were rotated 90 or more degrees. To address this, we developed a CNN to identify rotated radiographs. First, we trained a CNN using the resnet34 architecture to identify synthetically rotated radiographs from the [CXR14 dataset](http://openaccess.thecvf.com/content_cvpr_2017/papers/Wang_ChestX-ray8_Hospital-Scale_Chest_CVPR_2017_paper.pdf). We then fine-tuned this CNN using 11,000 manually reviewed PLCO radiographs. The rotated radiographs identified by this CNN in `preprocessing/plco_rotation_github.csv` were then corrected using ImageMagick. 

```bash
cd path_for_PLCO_tifs
mogrify -path destination_for_PLCO_pngs -trim +repage -colorspace RGB -auto-level -depth 8 -resize 512x512^ -format png "*.tif"
cd path_for_PLCO_pngs
while IFS=, read -ra cols; do mogrify -rotate 90 "${cols[0]}"; done < /path_to_repo/preprocessing/plco_rotation_github.csv
```

NLST radiographs were provided as DCM files by ACRIN. We chose to first convert them to TIF using DCMTK v3.6.1, then to PNGs with a minimum dimension of 512 pixels through ImageMagick to maintain consistency with the PLCO radiographs:

```bash
cd path_to_NLST_dcm
for x in *.dcm; do dcmj2pnm -O +ot +G $x "${x%.dcm}".tif; done;
mogrify -path destination_for_NLST_pngs -trim +repage -colorspace RGB -auto-level -depth 8 -resize 512x512^ -format png "*.tif"
```


The orientation of several NLST chest radiographs was manually corrected:

```
cd destination_for_NLST_pngs
mogrify -rotate "90" -flop 204025_CR_2000-01-01_135015_CHEST_CHEST_n1__00000_1.3.51.5146.1829.20030903.1123713.1.png
mogrify -rotate "-90" 208201_CR_2000-01-01_163352_CHEST_CHEST_n1__00000_2.16.840.1.113786.1.306662666.44.51.9597.png
mogrify -flip -flop 208704_CR_2000-01-01_133331_CHEST_CHEST_n1__00000_1.3.51.5146.1829.20030718.1122210.1.png
mogrify -rotate "-90" 215085_CR_2000-01-01_112945_CHEST_CHEST_n1__00000_1.3.51.5146.1829.20030605.1101942.1.png
```

We provide some input samples from the [PLCO dataset](https://biometry.nci.nih.gov/cdas/plco/) and [Kaggle's UNIFESP X-ray Body Part Classifier Competition dataset](https://www.kaggle.com/competitions/unifesp-x-ray-body-part-classifier) in `dummy_datasets/test_images/`.

### Running the Inference

This example is intended to be run in a conda environment. We provide a YAML file for the set-up of the environment at `cxr-lung-risk-nogpu.yaml` and `cxr-lung-risk-gpu.yaml`. Depending on whether your machine is equipped or not with a GPU, you can choose one or the other.

For instance, if the user's machine is equipped with a GPU:

```
git clone https://github.com/AIM-Harvard/CXR-Lung-Risk
cd /path/to/repo
conda env create -f cxr-lung-risk-gpu.yaml
conda activate cxr-lung-risk

cd src
python run_cxr_lung_risk.py
```

The `run_cxr_lung_risk.py` script will parse arguments from the `config.yaml` regarding whether or not to use a GPU - and which GPU to use - where to save the output and where to parse the input from.

Before running the inference, the user must download the model weight files.

The ensemble model weights can be downloaded from <add link> and can be downloaded either manually or running:

```
cd /path/to/repo
mkdir models

wget <add link> -O models

unzip models/ensemble-model-weights.zip -d ../models/ && rm models/ensemble-model-weights.zip
```

The InceptionV4 pre-trained model can be downloaded running the following:

```
mkdir -p /home/$YOUR_USERNAME/.cache/torch/hub/checkpoints
wget <add link> -O "/home/$YOUR_USERNAME/.cache/torch/hub/checkpoints/inceptionv4-8e4777a0.pth" --no-check-certificate
```

(N.B. - this is a workaround since the original link is often not responding or very slow in download speed).


# Data
PLCO (NCT00047385) data used for model development and testing [are available through the National Cancer Institute (NCI)](https://biometry.nci.nih.gov/cdas/plco/). NLST (NCT01696968) testing data [are available through the NCI and the American College of Radiology Imaging Network (ACRIN](https://biometry.nci.nih.gov/cdas/nlst/). Due to the terms of our data use agreement, we cannot distribute the original data. Please instead obtain the data directly from the NCI and ACRIN.

The `data` folder provides the image filenames and the CXR-Age estimates. "File" refers to image filenames and "CXR-Lung-Risk" refers to the CXR-Lung-Risk estimate: 
* `PLCO_Lung_Risk_Estimates.csv` contains the CXR-Lung-Risk estimates in the PLCO testing dataset.
* `NLST_Lung_Risk_Estimates.csv` contains the CXR-Lung-Risk estimate in the NLST testing dataset. The format for "File" is (original participant directory)_(original DCM filename).png

# Notes

In the case the user wants to run the pipeline from the source code using a GPU such as the Axxxx family, [it might be necessary to install a different version of `torch`](https://github.com/pytorch/pytorch/issues/52288).

For instance, to run the code using a machine equipped with an RTX A6000, after creating the Conda environment the user should activate it and run:

```
pip install -f https://download.pytorch.org/whl/cu113/torch_stable.html \
               torch==1.10.0+cu113 \
               torchaudio==0.10.0+cu113 \
               torchvision==0.11.1+cu113
```

To enable compatibility with such GPU. Any other `torch` versions compiled for CUDA=>11.3 should work as well.

Running the pipeline from the MHub CUDA-enabled container we provide will take care of this without any action from the user.

# Acknowledgments

The authors thank the study participants, the investigators, and the NCI and ACRIN for the data collected in the PLCO and NLST trials. Original data collection for the ACRIN 6654 trial (NLST) was supported by NCI Cancer Imaging Program grants. We would also like to thank the FastAI and Pytorch communities for releasing their open source platforms. The authors further acknowledge financial support from NIH (DC: NIH (NCI) 5U01CA209414; HA: NIH-USA U24CA194354, NIH-USA U01CA190234, NIH-USA U01CA209414, and NIH-USA R35CA22052), the European Union - European Research Council (HA: 866504), the American Heart Association (ML: 810966; VR: 935176), the Massachusetts General Hospital Thrall Innovation award (ML), the Johnson & Johnson Innovation/National Academy of Medicine Healthy Longevity Quickfire Challenge (ML, VR),  and the National Academy of Medicine Healthy Longevity Catalyst Award (VR, JW, ML: 2000011734). The statements contained herein are solely those of the authors and do not represent or imply concurrence or endorsement by the above organizations. 






