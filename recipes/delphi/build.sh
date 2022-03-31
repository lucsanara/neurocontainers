#!/usr/bin/env bash
set -e

# this template file builds delphi and is then used as a docker base image for layer caching
export toolName='delphi'
export toolVersion='0.0.1' #the version number cannot contain a "-" - try to use x.x.x notation always
# Don't forget to update version change in README.md!!!!!
# toolName or toolVersion CANNOT contain capital letters or dashes or underscores (Docker registry does not accept this!)

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug=$1
fi

source ../main_setup.sh

###########################################################################################################################################
# IF POSSIBLE, PLEASE DOCUMENT EACH ARGUMENT PROVIDED TO NEURODOCKER. USE THE `# your comment` NOTATION THAT ALLOWS MID-COMMAND COMMENTS
# NOTE 1: THE QUOTES THAT ENCLOSE EACH COMMENT MUST BE BACKQUOTES (`). OTHER QUOTES WON'T WORK!
# NOTE 2: THE BACKSLASH (\) AT THE END OF EACH LINE MUST FOLLOW THE COMMENT. A BACKSLASH BEFORE THE COMMENT WON'T WORK!
# tensorflow-gpu requires cuda/cudnn. tensorflow does not. 
# pip doesn't install cuda for you (conda does), so pip install tensorflow-gpu won't work out of the box on most systems without a nvidia gpu
# conda 4.5.11/12: 3.7.0  4.6.14:3.7.3 4.7.10:3.7.13
# conda_install='_tflow_select=2.3.0=mkl tensorboard=1.15.0  tensorflow-base=1.15.0=mkl_py37he1670d9_0 tensorflow-estimator=1.15.0 tensorflow=1.15.0 _tflow_select=2.1.0=gpu tensorflow-gpu=1.15.0 ' `# tensorflow-gpu requires cuda/cudnn. tensorflow does not. pip doesn't install cuda for you (pip does), so conda install tensorflow-gpu won't work out of the box on most systems without a nvidia gpu.`\

##########################################################################################################################################
neurodocker generate ${neurodocker_buildMode} \
   --base-image docker.io/tensorflow/tensorflow:1.15.0-gpu-py3 `# neurodebian makes it easy to install neuroimaging software, recommended as default` \
   --env DEBIAN_FRONTEND=noninteractive                 `# this disables interactive questions during package installs` \
   --pkg-manager apt                                    `# desired package manager, has to match the base image (e.g. debian needs apt; centos needs yum)` \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll"   `# define the ll command to show detailed list including hidden files`  \
   --run="chmod +x /usr/bin/ll"                         `# make ll command executable`  \
   --run="mkdir ${mountPointList}"                      `# create folders for singularity bind points` \
   --install wget git tar \
   --run="git clone https://github.com/mc2-project/delphi.git /opt/encryption" \
   --run="pip install -U ray[debug]==0.8.0"             `# ray 0.8.0 requires the python version 3.6/3.7` \
  > ${imageName}.${neurodocker_buildExt}                `# LAST COMMENT; NOT FOLLOWED BY BACKSLASH!`
   # --miniconda version=py37_4.11.0 `#py37_4.11.0` \
   #          conda_install='tensorflow-base=1.15.0=gpu_py37h9dcbed7_0' `# tensorflow-gpu requires cuda/cudnn. tensorflow does not. pip doesn't install cuda for you (pip does), so conda install tensorflow-gpu won't work out of the box on most systems without a nvidia gpu.`\
   
   # --run="pip install ray[tune]==0.8.0 requests scipy tensorflow==1.15.0"                      `# ` \
   # --run="pip install h5py==2.10"                      `# ` \
   # --run="pip install pandas==1.2.5"                      `# ` \
   # --run="pip install argparse"                      `# ` \
   # --run="pip install numpy"                      `# ` \
   # --env DEPLOY_PATH=/opt/${toolName}-latest/           `# specify a path where ALL binary files will be exposed outside the container for the module system. Never expose a directory with system commands (like /bin/ /usr/bin ...)` \
   # --env DEPLOY_BINS=delphi:bidscoiner                 `# specify indiviual binaries (separated by :) on the PATH that should be exposed outside the container for the module system` \
   # --copy README.md /README.md                          `# include readme file in container` \
   # --copy delphi/* /opt/encryption                          `# include readme file in container` \

if [ "$1" != "" ]; then
   ./../main_build.sh
fi
