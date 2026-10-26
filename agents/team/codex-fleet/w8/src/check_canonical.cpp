#define main recompute_main
#include "canonical_base.cpp"
#undef main
string reference(const Sk&sk){
 string best;for(int pi=0;pi<120;pi++){string key;for(int j=0;j<9;j++){string a,b;for(int t=0;t<120;t++){a+=char('0'+sk[2*j][rename_type[pi][t]]);b+=char('0'+sk[2*j+1][rename_type[pi][t]]);}if(b<a)swap(a,b);key+=a;key+=b;}if(best.empty()||key<best)best=move(key);}return best;
}
int main(){
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 mt19937 rng(20261026);int tests=0;for(int k=0;k<240;k++){Sk sk;for(int j=0;j<18;j++)for(int t=0;t<120;t++)sk[j][t]=rng()%5;
  for(int j=0;j<(k<120?4:2);j++){int input=k<120?((k/24+j)%5):(rng()%5);for(int t=0;t<120;t++)sk[j][t]=perms[t][input];}
  if(canonical(sk)!=reference(sk)){cout<<"FAIL case="<<k<<'\n';return 1;}tests++;}
 cout<<"CHECK canonical matches full 120-permutation reference on "<<tests<<" seeded cases\n";
}
