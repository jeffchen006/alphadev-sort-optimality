from pathlib import Path
p=Path('round6/src/mcmc.c');s=p.read_text().replace('#include <unistd.h>','#include <unistd.h>\n#include <signal.h>\nstatic volatile sig_atomic_t stopping;\nstatic void stopped(int sig){(void)sig;stopping=1;}')
s=s.replace('  rs = seed *','  signal(SIGTERM,stopped);\n  rs = seed *')
s=s.replace('if (el > tlimit) break;','if (el > tlimit || stopping) break;\n      if(!(it&1048575)){printf("STATUS it=%ld acc=%ld cpu=%.3f bestwrong=%d\\n",it,acc,el,bestwrong);fflush(stdout);}')
s=s.replace('2048','128')
p.write_text(s)
p=Path('round6/src/mem_batch.py');s=p.read_text().replace("'round6/bin/mcmc'","'round6/bin/mcmc2'").replace("'-time','110'","'-time','75'").replace("'125',name","'165',name");p.write_text(s)
