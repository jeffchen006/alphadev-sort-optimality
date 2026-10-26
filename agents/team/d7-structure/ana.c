// d7-structure: per-program structure of sort5 M_out programs (stdin, "# prog" separated, with "out j, R" lines).
// Per program: value DAG (cmp / select nodes, movs erased), canonical DAG key under S5 input relabel (x reversal),
// lattice term of every cmov result, mov roles, liveness, output times.
// Output line: idx key240 key120 keyraw nmov ncmov blocks nNL nT nodup maxlive nregs outt movroles destuse lat
#include "../../upper/src/sim.h"
#include <stdint.h>
static Task T; static int NT;
static uint8_t vals[4000][5];
static int t01[32];
static uint64_t mix(uint64_t h, uint64_t x){ h^=x+0x9e3779b97f4a7c15ULL+(h<<6)+(h>>2); h*=0xff51afd7ed558ccdULL; return h^(h>>31); }
static int find_type(const uint8_t *v){ for(int k=0;k<NT;k++) if(!memcmp(vals[k],v,5)) return k; return -1; }
// lattice id of a column: monotone fam bitmask over 32 subsets; -1 = garbage involved, -2 = non lattice
static long latid(const uint8_t *a){
  uint32_t fam=1u<<31;
  for(int S=1;S<31;S++){ int t=t01[S]; if(a[t]==UNK) return -1; if(a[t]>=1) fam|=1u<<S; }
  // a[t]>=1 on 0/1 type means value 1 (max): check value = lattice eval on all types
  for(int k=0;k<NT;k++){ if(a[k]==UNK) return -1; int best=-1; for(int S=1;S<32;S++) if(fam>>S&1){ int m=99; for(int i=0;i<5;i++) if(S>>i&1 && vals[k][i]<m) m=vals[k][i]; if(m>best) best=m; }
    if(a[k]!=best) return -2; }
  return fam;
}
static int perms[120][5];
typedef struct { int op,d,s; } PI_; // op as sim.h; out: op=100+j, d=reg
static PI_ P[80]; static int NP;
static Ins prog[40]; static int L;
// structural DAG hashing under symmetry g (perm idx, rev)
static uint64_t dagkey(int g, int rev, uint64_t outh[5]){
  uint64_t reg[MAXR]; uint64_t flag=mix(7,7); int fsw=0; // flag node hash; fsw: canonical swap
  for(int r=0;r<MAXR;r++) reg[r]= r<5 ? mix(1000+perms[g][r],1) : mix(2000,2); // all garbage = one leaf
  for(int i=0;i<NP;i++){ PI_ x=P[i];
    if(x.op>=100){ outh[x.op-100 >=0 ? (rev?4-(x.op-100):x.op-100):0]=reg[x.d]; continue; }
    if(x.op==MOV){ reg[x.d]=reg[x.s]; continue; }
    if(x.op==CMP){ uint64_t a=reg[x.d], b=reg[x.s]; fsw = a>b; if(fsw){uint64_t z=a;a=b;b=z;} flag=mix(mix(mix(3,a),b),0); continue; }
    // cond set bits: 1=lt 2=eq 4=gt (relative to cmp d,s)
    int cs = x.op==CMOVL?1: x.op==CMOVLE?3: x.op==CMOVG?4: 6;
    if(fsw) cs = (cs&2)|((cs&1)<<2)|((cs&4)>>2);
    if(rev) cs = (cs&2)|((cs&1)<<2)|((cs&4)>>2);
    uint64_t th=reg[x.s], el=reg[x.d];
    if(th==el) continue;
    if(th>el){ uint64_t z=th; th=el; el=z; cs^=7; }
    reg[x.d]=mix(mix(mix(mix(5,flag),cs),th),el);
  }
  uint64_t h=11; for(int j=0;j<5;j++) h=mix(h,outh[j]); return h;
}
int main(int argc,char**argv){ int MODN=argc>2?atoi(argv[1]):1, MODR=argc>2?atoi(argv[2]):0;
  task_init(&T,5,34,MOD_OUT,0,"I1"); NT=T.T; gen_weak(5,vals);
  for(int S=1;S<31;S++){ uint8_t v[5]; for(int i=0;i<5;i++) v[i]=(S>>i&1); t01[S]=find_type(v); }
  { int np=0,a[5]; for(a[0]=0;a[0]<5;a[0]++)for(a[1]=0;a[1]<5;a[1]++)for(a[2]=0;a[2]<5;a[2]++)for(a[3]=0;a[3]<5;a[3]++)for(a[4]=0;a[4]<5;a[4]++){
    int u=0; for(int i=0;i<5;i++) u|=1<<a[i]; if(u!=31) continue; memcpy(perms[np++],a,sizeof a);} }
  char line[256]; int idx=-1; int smap[64];
  static State st;
  for(int done=0;!done;){
    char *gl=fgets(line,sizeof line,stdin);
    if(!gl || !strncmp(line,"# prog",6)){
      if(idx>=0 && NP>0 && idx%MODN==MODR){
        uint64_t oh[5], k240=~0ULL, k120=~0ULL, kraw;
        kraw=dagkey(0,0,oh);
        for(int rv=0;rv<2;rv++) for(int g=0;g<120;g++){ uint64_t k=dagkey(g,rv,oh); if(k<k240)k240=k; if(!rv&&k<k120)k120=k; }
        // simulate, lattice ids, blocks
        state_init(&T,&st);
        int nmov=0,ncm=0,nNL=0,nTg=0,nodup=0; char blocks[16]={0}; int nb=0;
        char lat[2048]; int lp=0; lat[0]=0; char cps[1024]; int cp=0; cps[0]=0; long cmin=-9,cmax=-9; char tags[40]; int nt=0; long seen[64]; int ns=0;
        int nregs=0; int used[MAXR]={0};
        for(int i=0;i<NP;i++){ PI_ x=P[i]; if(x.op>=100) continue;
          if(!used[x.d]){used[x.d]=1;nregs++;} if(!used[x.s]){used[x.s]=1;nregs++;}
          Ins in={x.op,x.d,x.s};
          uint8_t before[MAXT]; memcpy(before,st.r[x.d],T.TP);
          exec1(&T,&st,in);
          if(x.op==MOV) nmov++;
          else if(x.op==CMP){ nb++; if(nb<=15) blocks[nb-1]='0';
            uint8_t mn[MAXT],mx[MAXT]; for(int k=0;k<T.TP;k++){ uint8_t a=st.r[x.d][k],b=st.r[x.s][k]; mn[k]=(a==UNK||b==UNK)?UNK:(a<b?a:b); mx[k]=(a==UNK||b==UNK)?UNK:(a>b?a:b);} 
            cmin=latid(mn); cmax=latid(mx); long ia=latid(st.r[x.d]), ib=latid(st.r[x.s]);
            cp+=sprintf(cps+cp,"%s%lx:%lx", cp?",":"", (unsigned long)ia,(unsigned long)ib); }
          else { ncm++; if(nb>=1&&nb<=15) blocks[nb-1]++; if(!memcmp(before,st.r[x.d],T.T)) nodup++;
            long id=latid(st.r[x.d]); if(id==-1) nTg++; else if(id==-2) nNL++;
            { char tg; int dup=0; for(int q=0;q<ns;q++) if(seen[q]==id) dup=1; if(id>=0&&!dup) seen[ns++]=id; tg= id==-1?'T': id==-2?'N': id==cmin?(dup?'a':'m'): id==cmax?(dup?'A':'M'): (dup?'p':'o'); tags[nt++]=tg; }
            if(id<0) lp+=sprintf(lat+lp,"%s%s", lp?",":"", id==-1?"T":"N"); else lp+=sprintf(lat+lp,"%s%lx", lp?",":"", (unsigned long)id); }
        }
        // liveness & mov roles
        // reads: cmp d,s; cmov reads d,s; mov reads s; out reads d. writes: mov d (kill), cmov d (rw)
        int live[80][MAXR]; // live after instruction i
        int cur[MAXR]={0};
        for(int i=NP-1;i>=0;i--){ memcpy(live[i],cur,sizeof cur); PI_ x=P[i];
          if(x.op>=100){ cur[x.d]=1; continue; }
          if(x.op==MOV){ cur[x.d]=0; cur[x.s]=1; }
          else if(x.op==CMP){ cur[x.d]=1; cur[x.s]=1; }
          else { cur[x.d]=1; cur[x.s]=1; }
        }
        int maxlive=0; for(int i=0;i<NP;i++){ int c=0; for(int r=0;r<MAXR;r++) c+=live[i][r]; if(c>maxlive) maxlive=c; }
        // mov roles: after mov d,s at i: find first later instr that writes d or s (cmov/mov)
        char roles[16]; int nr=0;
        for(int i=0;i<NP;i++){ PI_ x=P[i]; if(x.op!=MOV) continue;
          char r='R';
          for(int j=i+1;j<NP;j++){ PI_ y=P[j]; if(y.op>=100||y.op==CMP) continue;
            if(y.d==x.s){ r = y.op==MOV?'s':'S'; break; } if(y.d==x.d){ r = y.op==MOV?'d':'D'; break; } }
          if(!live[i][x.s]) r='M'; // source dead after mov: pure rename (move)
          roles[nr++]=r; }
        roles[nr]=0;
        int outt[5]={-1,-1,-1,-1,-1}; int ii=0;
        for(int i=0;i<NP;i++){ if(P[i].op>=100) outt[P[i].op-100]=ii; else ii++; }
        tags[nt]=0; printf("%d %016llx %016llx %016llx %d %d %s %d %d %d %d %d %d,%d,%d,%d,%d %s %s %s %s\n",idx,(unsigned long long)k240,(unsigned long long)k120,(unsigned long long)kraw,
          nmov,ncm,blocks,nNL,nTg,nodup,maxlive,nregs,outt[0],outt[1],outt[2],outt[3],outt[4],nr?roles:"-",lat,tags,cps);
      }
      if(!gl){done=1;break;}
      idx++; NP=0; for(int r=0;r<64;r++) smap[r]=-1; continue;
    }
    char *h=strchr(line,'#'); if(h)*h=0;
    char op[32],a[16],b[16];
    if(sscanf(line," %31s %15[^, ] , %15s",op,a,b)!=3) continue;
    if(!strcmp(op,"out")){ int j=atoi(a); int x=atoi(b+1); int r= b[0]=='P'? x : (smap[x]<0? (smap[x]=5+x):smap[x]); P[NP].op=100+j; P[NP].d=r; P[NP].s=0; NP++; continue; }
    int o=-1; for(int k=1;k<NOPS;k++) if(!strcmp(op,OPN[k])) o=k;
    char *ab[2]={a,b}; int rr[2];
    for(int k=0;k<2;k++){ int x=atoi(ab[k]+1); rr[k]= ab[k][0]=='P'? x : 5+x; }
    P[NP].op=o; P[NP].d=rr[0]; P[NP].s=rr[1]; NP++;
  }
  return 0;
}
