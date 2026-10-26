#include <algorithm>
#include <array>
#include <cstring>
#include <map>
#include <string>
#include <vector>
using namespace std;
static vector<array<int,5>> ps;
static int ix[120][120];
extern "C" void init(){
 array<int,5> p={0,1,2,3,4};
 do{ps.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int i=0;i<120;i++)for(int t=0;t<120;t++){
  array<int,5> q;for(int k=0;k<5;k++)q[k]=ps[t][ps[i][k]];
  ix[i][t]=lower_bound(ps.begin(),ps.end(),q)-ps.begin();
 }
}
// Each comparison is a partition into at most three flag classes.
// Number class labels by first occurrence. This deliberately identifies
// more skeletons than operand-column equivalence does. It is used ONLY
// to omit redundant queries, never to transfer NONE results.
extern "C" void flagkey(const unsigned char* data,int n,unsigned char* out){
 string best;
 for(int i=0;i<120;i++){
  string key;key.reserve(120*n);bool worse=false;
  for(int j=0;j<n&&!worse;j++){
   int ren[3]={-1,-1,-1},nr=0;
   for(int t=0;t<120;t++){
    int u=ix[i][t],a=data[(2*j)*120+u],b=data[(2*j+1)*120+u];
    int f=(a>b)-(a<b)+1;if(ren[f]<0)ren[f]=nr++;
    key+=char(ren[f]);
   }
   if(!best.empty()&&key.compare(0,key.size(),best,0,key.size())>0)worse=true;
  }
  if(!worse&&(best.empty()||key<best))best=move(key);
 }
 memcpy(out,best.data(),120*n);
}
extern "C" void operandkey(const unsigned char* data,int n,unsigned char* out){
 string best;
 for(int rev=0;rev<2;rev++)for(int i=0;i<120;i++){
  string key;key.reserve(240*n);bool worse=false;
  for(int j=0;j<n&&!worse;j++){
   string a,b;a.reserve(120);b.reserve(120);
   for(int t=0;t<120;t++){
    int u=ix[i][rev?119-t:t],x=data[2*j*120+u],y=data[(2*j+1)*120+u];
    a+=char(rev?4-x:x);b+=char(rev?4-y:y);
   }
   if(b<a)swap(a,b);key+=a;key+=b;
   if(!best.empty()&&key.compare(0,key.size(),best,0,key.size())>0)worse=true;
  }
  if(!worse&&(best.empty()||key<best))best=move(key);
 }
 memcpy(out,best.data(),240*n);
}
