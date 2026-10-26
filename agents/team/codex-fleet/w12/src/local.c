#include "sim.h"
#include <time.h>
static Task T;
static long tested, correct, gcok;
static int garbage_cmp(const Ins *p,int L){
 State st;state_init(&T,&st);int cnt=0;
 for(int i=0;i<L;i++){
  if(p[i].op==CMP)for(int q=0;q<T.T;q++)if(st.r[p[i].d][q]==UNK||st.r[p[i].s][q]==UNK){cnt++;break;}
  exec1(&T,&st,p[i]);
 }
 return cnt;
}
static void test(Ins*p,int L,const char*tag){
 tested++; if(wrong(&T,p,L,NULL))return;correct++;
 int g=garbage_cmp(p,L);if(!g)return;gcok++;
 char fn[256];sprintf(fn,"programs/local_%s_%ld.s",tag,gcok);FILE*f=fopen(fn,"w");
 fprintf(f,"# n=5 model=out iset=I1 source=w12_local garbage_cmps=%d\n",g); print_prog(f,&T,p,L);fclose(f);
 printf("CANDIDATE %s\n",fn);fflush(stdout);
}
int main(int argc,char**argv){
 task_init(&T,5,12,MOD_OUT,0,"I1");Ins p[MAXL],q[MAXL];int L=read_prog(&T,argv[1],p);
 const char*tag=argv[2];
 for(int i=-1;i<L;i++){
  if(i>=0&&p[i].op!=MOV)continue;
  for(int op=CMOVL;op<=CMOVGE;op++){
   if(i<0&&op!=CMOVL)continue;
   for(int c=0;c<L;c++)if(p[c].op==CMP)
    for(int side=0;side<2;side++)for(int r=0;r<T.nr;r++){
     memcpy(q,p,sizeof q);if(i>=0)q[i].op=op;
     if(side)q[c].s=r;else q[c].d=r;
     test(q,L,tag);
    }
  }
 }
 // Change two mov instructions to conditional copies, then substitute a cmp operand.
 for(int i=0;i<L;i++)if(p[i].op==MOV)for(int j=i+1;j<L;j++)if(p[j].op==MOV)
 for(int a=CMOVL;a<=CMOVGE;a++)for(int b=CMOVL;b<=CMOVGE;b++)
 for(int c=j+1;c<L;c++)if(p[c].op==CMP)for(int side=0;side<2;side++)for(int r=0;r<T.nr;r++){
  memcpy(q,p,sizeof q);q[i].op=a;q[j].op=b;
  if(side)q[c].s=r;else q[c].d=r;test(q,L,tag);
 }
 printf("tested=%ld correct=%ld garbage_correct=%ld\n",tested,correct,gcok);
}
