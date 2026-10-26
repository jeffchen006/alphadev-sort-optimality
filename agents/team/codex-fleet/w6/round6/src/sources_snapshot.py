from pathlib import Path
s=Path('round6/src/mcmc.c').read_text().replace('#include <signal.h>\nstatic volatile sig_atomic_t stopping;\nstatic void stopped(int sig){(void)sig;stopping=1;}\n','').replace('  signal(SIGTERM,stopped);\n','').replace('if (el > tlimit || stopping) break;\n      if(!(it&1048575)){printf("STATUS it=%ld acc=%ld cpu=%.3f bestwrong=%d\\n",it,acc,el,bestwrong);fflush(stdout);}','if (el > tlimit) break;').replace('128','2048')
Path('round6/src/mcmc_initial.c').write_text(s)
