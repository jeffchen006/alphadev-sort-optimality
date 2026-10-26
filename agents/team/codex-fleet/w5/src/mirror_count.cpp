#include <cstdio>
#include <cstdint>
#include <utility>
#include <vector>
using namespace std;
int main(){
  vector<pair<int,int>>pairs;for(int a=0;a<5;a++)for(int b=a+1;b<5;b++)pairs.push_back({a,b});
  for(int c=10;c<=12;c++){
    int half=c/2,templates=1;for(int i=0;i<half;i++)templates*=10;if(c%2)templates*=2;
    int correct=0;
    for(int code=0;code<templates;code++){
      int z=code;pair<int,int>p[12];
      if(c%2){p[half]=(z%2)?pair<int,int>{0,4}:pair<int,int>{1,3};z/=2;}
      for(int i=0;i<half;i++){p[i]=pairs[z%10];z/=10;p[c-1-i]={4-p[i].second,4-p[i].first};}
      uint32_t r[5]={0xaaaaaaaa,0xcccccccc,0xf0f0f0f0,0xff00ff00,0xffff0000};
      for(int i=0;i<c;i++){auto[a,b]=p[i];auto x=r[a],y=r[b];r[a]=x&y;r[b]=x|y;}
      bool ok=true;for(int i=0;i<4;i++)if(r[i]&~r[i+1])ok=false;correct+=ok;
    }
    printf("c=%d templates=%d sorting=%d\n",c,templates,correct);
  }
}
