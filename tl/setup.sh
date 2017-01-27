#!/usr/bin/env bash

# Get the dir of this script. [http://stackoverflow.com/a/246128]
tl_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a tmp work dir. [http://stackoverflow.com/a/34676160]
tmp_dir=`mktemp -d -p "$tl_dir"`

# Fetch and extract TeX Live installer.
cd $tmp_dir
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-20*

# Install TeX Live using custom profile.
./install-tl --profile=$tl_dir/texlive.profile

# Install extra packages.
readarray -t texlive_packages < $tl_dir/texlive.packages
tlmgr install ${texlive_packages[@]}

# Post install config.
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
# MEMO: "/tmp/texlive" is defined as root in "texlive.profile".

# NOTE: we do no cleanup, but this is meant
#   for a simple Travis session, so it's ok.
