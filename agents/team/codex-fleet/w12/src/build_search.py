from pathlib import Path
s=Path('src/sim.h').read_text()
p=s.index('static int wrong_out(')
s=s[:p]+'#include "branch_eval.h"\nstatic int wrong_out(const Task*t,const Ins*p,int L,int*orr,int*ort){return branch_eval(t,p,L,orr,ort,NULL);}\n'+s[p:].replace('static int wrong_out(', 'static int original_wrong_out(',1)
Path('src/sim_branch.h').write_text(s)
s=Path('src/mcmc.c').read_text().replace('#include "sim.h"','#include "sim_branch.h"')
s=s.replace('static Task T;', 'static Task T;\nstatic double gpen=50;\nstatic int lastgc;\nstatic long gevals,gaccept;\nstatic int bestgw=999999;')
a=s.index('static int eval_from(');b=s.index('// ---- collection',a)
s=s[:a]+'''static int eval_from(const Ins*p,int L,int lo){
 int w=branch_eval(&T,p,L,NULL,NULL,&lastgc);gevals+=(lastgc>0);return w;
}

'''+s[b:]
s=s.replace('if (!strcmp(argv[i], "-n"))', 'if (!strcmp(argv[i], "-gpen")) gpen=atof(argv[++i]);\n    else if (!strcmp(argv[i], "-n"))')
s=s.replace('snap_build(cur, L, 0);\n      int w = final_cost(&SN[L]);','int w = eval_from(cur,L,0);')
s=s.replace('cc = W * w + lam * count_len(cur, L)', 'cc = W * w + gpen*(lastgc==0) + lam * count_len(cur, L)')
s=s.replace('double pc = W * w + lam * len', 'double pc = W * w + gpen*(lastgc==0) + lam * len')
s=s.replace('snap_build(cur, L, lo);','gaccept+=(lastgc>0);\n      if(lastgc>0&&w<bestgw){bestgw=w;char fn[512];sprintf(fn,"%s_gbest.s",out);FILE*f=fopen(fn,"w");fprintf(f,"# n=5 model=out iset=I1 source=w12_search wrong=%d garbage_cmps=%d\\n",w,lastgc);print_prog(f,&T,cur,L);fclose(f);printf("GARBAGE_BEST wrong=%d gc=%d it=%ld\\n",w,lastgc,it);fflush(stdout);}')
s=s.replace('if (w == 0 && (len < bestlen || report_all))', 'if (w == 0 && (lastgc>0 || len<=31) && (len < bestlen || report_all))')
s=s.replace('printf("collected=%ld ", ncoll);','printf("gevals=%ld gaccept=%ld bestgw=%d collected=%ld ",gevals,gaccept,bestgw,ncoll);')
# preserve a bounded search log on wall-limited runs
s=s.replace('if (el > tlimit) break;', 'if((it&262143)==0){printf("PROGRESS it=%ld cpu=%.1f bestgw=%d gaccept=%ld cost=%.1f\\n",it,el,bestgw,gaccept,cc);fflush(stdout);}\n      if (el > tlimit) break;')
Path('src/gmcmc.c').write_text(s)
