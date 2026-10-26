// Conservative per-comparison path split. Retain flag correlation within a block.
static int branch_eval(const Task*t,const Ins*p,int L,int*orr,int*ort,int*gcount){
 static __thread uint8_t v[3][MAXR][MAXT], merged[MAXR][MAXT], active[3][MAXT];
 int best[5],br[5],bt[5];for(int j=0;j<t->n;j++){best[j]=100000;br[j]=0;bt[j]=-1;}
 for(int f=0;f<3;f++){
  memset(active[f],1,t->TP);
  for(int r=0;r<t->nr;r++)memcpy(v[f][r],t->init[r],t->TP);
 }
 int gc=0;
 for(int i=0;i<L;i++){
  Ins in=p[i];if(in.op==NOP)continue;
  if(in.op==CMP){
   // Merge paths before the comparison. Keep exact equal values; forget other correlations.
   for(int r=0;r<t->nr;r++)for(int k=0;k<t->TP;k++){
    int val=-1;for(int f=0;f<3;f++)if(active[f][k]){
     int x=v[f][r][k];if(val<0)val=x;else if(val!=x)val=UNK;
    }
    merged[r][k]=val<0?UNK:val;
   }
   int has=0;
   for(int k=0;k<t->TP;k++){
    int a=merged[in.d][k],b=merged[in.s][k],u=(a==UNK||b==UNK);
    if(k<t->T&&u)has=1;
    int fl=a<b?1:a>b?2:0;
    for(int f=0;f<3;f++)active[f][k]=in.d==in.s?(f==0):(u||f==fl);
   }
   gc+=has;
   for(int f=0;f<3;f++)for(int r=0;r<t->nr;r++)memcpy(v[f][r],merged[r],t->TP);
  }else{
   for(int f=0;f<3;f++){
    int mv=in.op==MOV||in.op==CMOVL&&f==1||in.op==CMOVG&&f==2||in.op==CMOVLE&&f!=2||in.op==CMOVGE&&f!=1;
    if(mv)memcpy(v[f][in.d],v[f][in.s],t->TP);
   }
   for(int j=0;j<t->n;j++){
    int c=0;for(int k=0;k<t->T;k++){
     int bad=0;for(int f=0;f<3;f++)if(active[f][k]&&v[f][in.d][k]!=t->expv[j][k])bad=1;
     c+=bad;
    }
    if(c<best[j]){best[j]=c;br[j]=in.d;bt[j]=i;}
   }
  }
 }
 int sum=0;for(int j=0;j<t->n;j++){sum+=best[j];if(orr)orr[j]=br[j];if(ort)ort[j]=bt[j];}
 if(gcount)*gcount=gc;return sum;
}
