#!/bin/bash
# Hyun-gwan Seo <westporch@gmail.com>

KERNEL_SOURCE_DIR=/usr/local/src
KERNEL_VERSION=$1
KERNEL_SOURCE_BASE=$KERNEL_SOURCE_DIR/linux-$KERNEL_VERSION 
HOST_NAME=`hostname`
CPU_CORES=`cat /proc/cpuinfo | grep -c processor`

# Parameter check. Only one parameter(kernel version) is required.
    if [ $# -ne 1 ]; then
        echo "[Error] Please specify the kernel version."
        echo "Usage example: $0 4.7.6(kernel version)" 
        exit
    fi  

# Download kernel source from kernel.org and uncompress it.
function get_kernel_source()
{
    wget -P $KERNEL_SOURCE_DIR https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz
    unxz $KERNEL_SOURCE_DIR/linux-$KERNEL_VERSION.tar.xz
    tar xvf $KERNEL_SOURCE_DIR/linux-$KERNEL_VERSION.tar -C $KERNEL_SOURCE_DIR
}

# Install required packages for kernel compile.
function install_required_packages()
{
    apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package -y   # Package size is about 814MB.
}

# Copy your existing linux kernel config file.
function copy_existing_kernel_config_file()
{
    cp /boot/config-$(uname -r) $KERNEL_SOURCE_BASE/.config
}

# Configure the kernel using command(make menuconfig).
function make_menuconfig()
{
    cd $KERNEL_SOURCE_BASE
    make menuconfig
    make-kpkg clean     # Clean the source tree and reset the kernel packages.
}

# Compile the kernel.
function run_kernel_compile()
{
    cd $KERNEL_SOURCE_BASE
    fakeroot make-kpkg -j$CPU_CORES --initrd --revision=1.0.$HOST_NAME kernel_image kernel_headers
}

get_kernel_source    
install_required_packages
copy_existing_kernel_config_file
make_menuconfig
run_kernel_compile
