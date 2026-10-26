#define main backward_original_main
#include "backward.cpp"
#undef main
int main(){
 char a0[]="check",a1[]="5",a2[]="0",a3[]="1",a4[]="round5/candidates/backward_check_unused";char *av[]={a0,a1,a2,a3,a4};backward_original_main(5,av);
 long checks=0;for(int o=0;o<(int)ops.size();o++)for(int j=0;j<NT;j++){
  Bits s;put(s,j);Bits expected;
  for(int i=0;i<NT;i++){auto p=perms[i];auto q=ops[o];if(p[q.a]>p[q.b])swap(p[q.c],p[q.d]);if(p==perms[j])put(expected,i);}
  assert(before(s,o)==expected);assert(card(expected)<=2);checks++;
 }
 mt19937_64 rng(5231321);for(int z=0;z<1000;z++){
  Bits s;int n=1+rng()%120;for(int k=0;k<n;k++)put(s,rng()%120);Bits key=canon(s);
  for(int q=0;q<10;q++){Bits t;int permutation=rng()%120;for(int i:ids(s))put(t,ren[permutation][i]);assert(canon(t)==key);checks++;}
  for(int o=0;o<(int)ops.size();o++)assert(card(before(s,o))<=2*card(s)),checks++;
 }
 cout<<"CHECK_PASS inverse_and_wire_equivalence_checks="<<checks<<"\n";
}
