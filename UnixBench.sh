#!/usr/bin/env bash
#
# Author: ade
#
# Desc  : A Unixbench script

work_dir='/opt/Unixbench'
download_url='https://github.com/kdlucas/byte-unixbench/archive/v5.1.3.tar.gz'
tarball_name='UnixBench5.1.3.tar.gz'

# Check Requirements
function CheckRequirements(){
  # Need Root
  [[ $EUID -ne 0 ]] && echo 'This Script Need Run Under Root User.' && exit 1
  # os type
  [[ -f /etc/centos-release ]] && os='centos'
  [[ ! -z "`egrep -i ubuntu /etc/issue`" ]] && os='ubuntu'
  [[ ! -z "`egrep -i debian /etc/issue`" ]] && os='debian'
  [[ "$os" == '' ]] && echo  'OS Is Not Support.' && exit 1
}

function InstallRequirements(){
  if [ $os == 'centos' ];then
    yum install -y gcc make automake autoconf time perl-Time-HiRes
  else
    apt-get update -y
    apt-get install gcc make automake autoconf time perl
  fi
}

#CheckRequirements
#InstallRequirements

echo "OSType:"$os


# download Unixbench
mkdir -p ${work_dir}
cd ${work_dir}
if [ -s "${tarball_name}" ]; then
  echo "[Found]${tarball_name}"
else
  echo "[Not Found]${tarball_name}"
  echo "Downloading..."
  if ! wget -c ${download_url} -O ${tarball_name} ; then
    echo 'Download Failed.' && exit 1
  fi
fi

mkdir -p ${work_dir}/UnixBench
tar -xvf ${tarball_name} -C ${work_dir}/UnixBench
cd UnixBench

# make & run
mk_dir=$(find ${work_dir} -name "Makefile" | sed 's/Makefile//g' )
echo 'Makefile:'$mk_dir
if [ -s "$mk_dir" ];then
  cd $mk_dir
  make
  ./Run
fi
