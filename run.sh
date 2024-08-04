#!/bin/bash

##### SET FOLLOWING VARS #####
CONDA_DIR="/home/$USER/src/miniconda3"
SERVER_NAME="192.168.0.187"
###### END OF VARIABLES ######





# source base conda env in this script's subshell
# https://github.com/conda/conda/issues/7980
source $CONDA_DIR/etc/profile.d/conda.sh

# set working dir to this script's location:
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
INSTALL_DIR="$SCRIPT_DIR/install_files"
CONDA_ENV_DIR="$INSTALL_DIR/conda_env"

available() { command -v $1 >/dev/null; }

cd $SCRIPT_DIR

# check if miniconda already installed
if ! available conda; then
    echo "miniconda is not yet installed. Install it first."
    exit 0
fi

# Get miniconda directory 
# bash parameter expansion https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
# https://superuser.com/a/1001979
#CONDA_BIN=$(which conda)
#SUBSTR="/bin/conda"
#END_POS=$(( ${#CONDA_BIN} - ${#SUBSTR} ))
#CONDA_DIR=${CONDA_BIN:0:END_POS}

# check if install dir already exists
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p $INSTALL_DIR
fi

# check if conda env already exists, create if not yet done
if [ ! -d "$CONDA_ENV_DIR" ]; then
    conda create --no-shortcuts -y -k --prefix "$CONDA_ENV_DIR" python=3.10
fi

# confirm if conda env is actually created
if [ ! -f "$CONDA_ENV_DIR/bin/python" ]; then
    echo "python is not found in $CONDA_ENV_DIR/bin"
    echo "exiting."
    exit 0
fi

# activate conda env
conda activate $CONDA_ENV_DIR || echo "Miniconda hook not found."

# run setup.py
echo "Running setup.py"
export GRADIO_SERVER_NAME=$SERVER_NAME
python setup.py