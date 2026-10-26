#!/bin/bash
# x86 agent: build SBCL + ACL2 + certify x86isa (formal x86 model) in agents/x86/ext. Logs: logs/acl2_*.log
set -ex
E=/path/to/repo/agents/x86/ext
L=$E/../logs
cd $E; mkdir -p dl; cd dl
[ -f sbcl.tar.bz2 ] || curl -sL -o sbcl.tar.bz2 https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.9/sbcl-2.4.9-x86-64-linux-binary.tar.bz2
[ -d sbcl-2.4.9-x86-64-linux ] || tar xjf sbcl.tar.bz2
cd sbcl-2.4.9-x86-64-linux && INSTALL_ROOT=$E/sbcl-inst sh install.sh > /dev/null
export PATH=$E/sbcl-inst/bin:$PATH SBCL_HOME=$E/sbcl-inst/lib/sbcl
sbcl --version
cd $E/acl2 && git sparse-checkout disable
make LISP=sbcl > $L/acl2_make.log 2>&1
ls -la saved_acl2
cd books && ./build/cert.pl -j4 --acl2 $E/acl2/saved_acl2 projects/x86isa/tools/execution/top > $L/acl2_cert.log 2>&1
echo DONE
