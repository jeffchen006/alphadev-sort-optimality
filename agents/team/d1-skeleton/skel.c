// d1-skeleton: extract cmp skeletons from sort5 M_out programs (stdin, "# prog" separated).
// Per program: simulate over 541 weak orders (strict 3-valued garbage), record operand value functions
// of each cmp, describe each as lattice polynomial (via 0/1 types), canonical key under S5 x reversal x operand swap.
#include "../../upper/src/sim.h"
#include <stdint.h>
static Task T;
static int NT;
static uint8_t vals[4000][5];
static int permidx[120][5];
static int tymap[240][MAXT]; // tymap[g][t] = index of type g(t)
static int find_type(const uint8_t *v){ for(int k=0;k<NT;k++) if(!memcmp(vals[k],v,5)) return k; return -1; }
static uint64_t h64(uint64_t h, uint64_t x){ h^=x+0x9e3779b97f4a7c15ULL+(h<<6)+(h>>2); return h*0xff51afd7ed558ccdULL; }
// formula of value vector a: monotone family over subsets via 0/1 types
static int t01[32];
static void formula(const uint8_t *a, char *buf){
  // returns e.g. "max(min(0,1),2)" as list of minimal sets; check consistency
  int fam=0; // bitmask over 32 subsets
  for(int S=1;S<31;S++){ int t=t01[S]; if(a[t]==UNK){strcpy(buf,"T?");return;} if(a[t]==1) fam|=1u<<S; }
  fam|=1u<<31; // full set true
  // minimal sets
  char *p=buf; int first=1; *p=0;
  for(int S=1;S<32;S++) if(fam>>S&1){ int minimal=1; for(int U=1;U<32;U++) if(U!=S && (U&S)==U && (fam>>U&1)) minimal=0;
    if(!minimal) continue; if(!first) *p++='|'; first=0; for(int i=0;i<5;i++) if(S>>i&1) *p++='0'+i; }
  *p=0;
  // verify: value = max over minimal sets of min
  for(int k=0;k<NT;k++){ int best=-1; for(int S=1;S<32;S++) if(fam>>S&1){ int m=99; for(int i=0;i<5;i++) if(S>>i&1 && vals[k][i]<m) m=vals[k][i]; if(m>best) best=m; }
    if(a[k]!=best){ strcat(buf,"!NL"); return; } }
}
static int MODN=1,MODR=0;
int main(int argc,char**argv){ if(argc>2){MODN=atoi(argv[1]);MODR=atoi(argv[2]);}
  task_init(&T,5,34,MOD_OUT,0,"I1"); NT=T.T; gen_weak(5,vals);
  for(int S=1;S<31;S++){ uint8_t v[5]; for(int i=0;i<5;i++) v[i]=(S>>i&1); t01[S]=find_type(v); }
  int np=0; int pp[5]={0,1,2,3,4};
  // all perms
  int a[5];
  for(a[0]=0;a[0]<5;a[0]++)for(a[1]=0;a[1]<5;a[1]++)for(a[2]=0;a[2]<5;a[2]++)for(a[3]=0;a[3]<5;a[3]++)for(a[4]=0;a[4]<5;a[4]++){
    int u=0; for(int i=0;i<5;i++) u|=1<<a[i]; if(u!=31) continue; memcpy(permidx[np++],a,sizeof a);}
  for(int g=0;g<240;g++){ int *pi=permidx[g%120]; int rev=g/120;
    for(int k=0;k<NT;k++){ uint8_t v[5]; int mx=0; for(int i=0;i<5;i++) if(vals[k][i]>mx) mx=vals[k][i];
      for(int i=0;i<5;i++){ uint8_t x=vals[k][pi[i]]; v[i]= rev? mx-x : x; } tymap[g][k]=find_type(v);} }
  static char line[256]; Ins p[MAXL]; int L=0, have=0; long pid=0;
  static State st; static uint8_t fv[16][MAXT]; static uint8_t opa[16][MAXT], opb[16][MAXT];
  for(int eof=0;!eof;){
    int got = fgets(line,sizeof line,stdin)!=NULL; if(!got) eof=1;
    if(eof || !strncmp(line,"# prog",6)){
      if(have && L>0 && pid%MODN!=MODR){pid++;}
      else if(have && L>0){
        // simulate
        state_init(&T,&st); int c=0;
        for(int i=0;i<L;i++){ if(p[i].op==CMP){ memcpy(opa[c],st.r[p[i].d],NT); memcpy(opb[c],st.r[p[i].s],NT);} exec1(&T,&st,p[i]); if(p[i].op==CMP){ memcpy(fv[c],st.f,NT); c++; } }
        // canonical key
        uint64_t best=~0ULL; int bg=-1;
        for(int g=0;g<240;g++){ uint64_t h=c; int rev=g/120;
          for(int j=0;j<c;j++){ uint8_t tf[MAXT]; int sw=-1;
            for(int k=0;k<NT;k++){ uint8_t f=fv[j][tymap[g][k]]; if(rev&&(f==1||f==2)) f=3-f; tf[k]=f; }
            // orient
            for(int k=0;k<NT&&sw<0;k++) if(tf[k]==1) sw=0; else if(tf[k]==2) sw=1;
            uint64_t hh=0; for(int k=0;k<NT;k++){ uint8_t f=tf[k]; if(sw==1&&(f==1||f==2)) f=3-f; hh=h64(hh,f);} h=h64(h,hh);}
          if(h<best){best=h;bg=g;} }
        printf("%ld %d %016llx",pid,c,(unsigned long long)best);
        for(int j=0;j<c;j++){ char b1[200],b2[200]; formula(opa[j],b1); formula(opb[j],b2); printf(" %s:%s",b1,b2);} printf("\n");
        pid++;
      }
      have=1; L=0; nsmap=0; continue;
    }
    char *h=strchr(line,'#'); if(h)*h=0; char op[32],ra[16],rb[16];
    if(sscanf(line," %31s %15[^, ] , %15s",op,ra,rb)!=3) continue;
    if(!strcmp(op,"out")) continue;
    int o=-1; for(int k=1;k<NOPS;k++) if(!strcmp(op,OPN[k])) o=k; if(o<0){fprintf(stderr,"bad %s\n",op);return 1;}
    p[L].op=o; p[L].d=parse_reg(&T,ra); p[L].s=parse_reg(&T,rb); L++;
  }
  return 0;
}
