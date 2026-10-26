from pathlib import Path
p=Path('round6/src/mcmc.c');s=p.read_text()
s=s.replace('static Task T;', '''static Task T;
static int bestwrong = 100000, savednear;
static uint64_t nearhash[2048];
static int failures(const Ins *p,int L) {
  State st;run(&T,&st,p,L);int n=0;
  for(int t=0;t<T.T;t++){int bad=0;for(int j=0;j<T.n;j++)bad|=st.r[j][t]!=T.expv[j][t];n+=bad;}
  return n;
}
static void save_near(const Ins*p,int L,int error,const char*out,int iteration) {
 if(T.model!=MOD_MEM)return;
 int record=error<bestwrong;
 if(!record && (error>50 || savednear>=2048))return;
 int fail=failures(p,L);uint64_t h=1469598103934665603ULL;
 for(int i=0;i<L;i++)h=(h^((p[i].op<<16)|(p[i].d<<8)|p[i].s))*1099511628211ULL;
 for(int i=0;i<savednear;i++)if(nearhash[i]==h)return;
 if(record)bestwrong=error;
 char fn[768];sprintf(fn,"%s_best.s",out);
 if(record){FILE*f=fopen(fn,"w");fprintf(f,"# n=5 model=mem iset=I1 error=%d failed_orders=%d\\n",error,fail);print_prog(f,&T,p,L);fclose(f);
 printf("NEAR error=%d fail=%d it=%d file=%s\\n",error,fail,iteration,fn);fflush(stdout);}
 if(fail>10||savednear>=2048)return;
 nearhash[savednear++]=h;sprintf(fn,"%s_near_%d.s",out,savednear);
 FILE*f=fopen(fn,"w");fprintf(f,"# n=5 model=mem iset=I1 error=%d failed_orders=%d\\n",error,fail);print_prog(f,&T,p,L);fclose(f);
}
''')
s=s.replace('restarts++;','restarts++;\n      save_near(cur,L,w,out,it);')
s=s.replace('snap_build(cur, L, lo);\n      if', 'snap_build(cur, L, lo);\n      save_near(cur,L,w,out,it);\n      if',1)
s=s.replace('static int bestwrong = 100000, savednear;','static int bestwrong = 100000, savednear;\nstatic int partner_moves;')
s=s.replace('} else {                       // delete', '''} else if (mv < 96) {          // partner select under an independent comparison
      if(prop[a].op < CMOVL) continue;
      int count=0, cmps[MAXL];for(int k=0;k<a;k++)if(prop[k].op==CMP)cmps[count++]=k;
      if(!count)continue;int at=cmps[rnd()%count];
      prop[a].s=(rnd()&1)?prop[at].d:prop[at].s;
      if(!legal(&T,prop[a]))continue;partner_moves++;
    } else {                       // delete''')
s=s.replace('  printf("collected=%ld ", ncoll);','  printf("bestwrong=%d savednear=%d partner_moves=%d ",bestwrong,savednear,partner_moves);\n  printf("collected=%ld ", ncoll);')
p.write_text(s)
