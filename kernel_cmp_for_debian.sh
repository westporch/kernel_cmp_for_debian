#!/bin/bash
# Hyun-gwan Seo

KERNEL_SOURCE_DIR=/usr/local/src
KERNEL_VERSION=$1

# Parameter check. Only one parameter(kernel version) is required.
    if [ $# -ne 1 ]; then
        echo "[Error] Please specify the kernel version."
        echo "Usage example: $0 4.7.6(kernel version)" 
        exit
    fi  

# Download kernel source from kernel.org and uncompress it.
function get_kernel_source()
{
    #wget -P $KERNEL_SOURCE_DIR https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.7.6.tar.xz
    wget -P $KERNEL_SOURCE_DIR https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz
    unxz $KERNEL_SOURCE_DIR/*.xz
    tar xvf $KERNEL_SOURCE_DIR/*.tar -C $KERNEL_SOURCE_DIR
}

get__kernel_source    
