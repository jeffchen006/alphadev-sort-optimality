// d7: strict M_out check with free snapshot outputs (upper sim.h wrong_out). stdin: programs separated by "# " header
// lines (header kept as label). Prints: label | k c g v wrong
#include "../../upper/src/sim.h"
static Task T;
int main(){ task_init(&T,5,34,MOD_OUT,0,"I1");
  char line[512], lab[512]=""; Ins p[MAXL]; int L=0, have=0;
  int map[64];
  for(;;){ char *g=fgets(line,sizeof line,stdin);
    if(!g || line[0]=='#'){ if(have){ int c=0,gg=0,v=0; for(int i=0;i<L;i++){ if(p[i].op==CMP)c++; else if(p[i].op==MOV)v++; else gg++; }
        printf("%s | %d %d %d %d %d\n", lab, L, c, gg, v, wrong_out(&T,p,L,NULL,NULL)); }
      if(!g) break; strncpy(lab,line,511); lab[strcspn(lab,"\n")]=0; L=0; have=1; for(int r=0;r<64;r++)map[r]=-1; continue; }
    char op[32],a[16],b[16]; if(sscanf(line," %31s %15[^, ] , %15s",op,a,b)!=3) continue;
    if(!strcmp(op,"out")) continue;
    int o=-1; for(int k=1;k<NOPS;k++) if(!strcmp(op,OPN[k])) o=k; if(o<0) continue;
    int rr[2]; char *ab[2]={a,b}; int bad=0;
    for(int k=0;k<2;k++){ int x=atoi(ab[k]+1); if(ab[k][0]=='P'&&x<5) rr[k]=x; else if(ab[k][0]=='S'&&x<29) rr[k]=5+x; else bad=1; }
    if(bad||L>=MAXL) continue; p[L].op=o; p[L].d=rr[0]; p[L].s=rr[1]; L++; }
}
