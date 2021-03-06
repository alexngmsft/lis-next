#!/bin/bash

# This scripts neeeds to be run in /{user}/rpmbuild/SPECS

cd /$HOME/rpmbuild/SPECS

Runbuild()
{
        rm -vrf /root/rpmbuild/RPMS/*
        rm -vrf /root/rpmbuild/SPECS/SRPMS/*
       rpmbuild --clean /root/rpmbuild/SPECS/lis-rhel7.spec
#	rpmbuild --clean /root/rpmbuild/SPECS/lis-centos7.spec
#	rpmbuild --clean /root/rpmbuild/SPECS/lis-oracle7.spec
        rpmbuild -ba /root/rpmbuild/SPECS/lis-rhel7.spec
#	rpmbuild --ba /root/rpmbuild/SPECS/lis-centos7.spec
#	rpmbuild --ba /root/rpmbuild/SPECS/lis-oracle7.spec
}


# Get kernel version and trim last 3 charcter for preamble . 

kernelVersionString=$(uname -r)
regex='([0-9]+\.[0-9]+\.[0-9]+)-([0-9]+)'

if [[ "${kernelVersionString}" =~ $regex  ]]; then
        kernelVersion=${BASH_REMATCH[0]}
        kernelChange=${BASH_REMATCH[2]}
fi

lastno=$(echo $kernelVersion | rev |cut -c 1 | rev )
nextno=$((lastno+1))
nextkern=$(echo $kernelVersion | rev |cut -c 2- | rev)$nextno


# Now create a preamble file with current kernel and next kernel.
echo -e "REQUIRES :  kernel >= $kernelVersion\nREQUIRES :  kernel < $nextkern" > preamble

echo -e "%defattr (-,root,root)\n/lib/modules/%2-%1\n%config /etc/depmod.d/hyperv.conf" > config
Runbuild

# cleanup 
#rm -rf config
