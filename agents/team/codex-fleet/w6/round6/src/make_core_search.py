from pathlib import Path
s=Path('round5/src/new_search.cpp').read_text()
s=s.replace('#include <sys/resource.h>', '#include <sys/resource.h>\n#include <csignal>\nstatic volatile sig_atomic_t stopping;\nstatic void stopped(int){stopping=1;}')
s=s.replace('int main(int argc,char**argv){','int main(int argc,char**argv){\n  signal(SIGTERM,stopped);')
s=s.replace('if(!(iterations&4095)&&cpu()-begun>limit)break;', 'if(!(iterations&4095)&&(cpu()-begun>limit||stopping))break;\n    if(!(iterations&1048575))cerr<<"PROGRESS iterations="<<iterations<<" accepted="<<accepted<<" cpu="<<cpu()-begun<<"\\n";')
Path('round6/src/core_search.cpp').write_text(s)
