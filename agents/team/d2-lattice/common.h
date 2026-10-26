// common.h -- hashing, exact interning, key sets (enum agent)
#pragma once
#include <bits/stdc++.h>
#include <omp.h>
using namespace std;
typedef uint32_t u32; typedef uint64_t u64; typedef uint8_t u8; typedef unsigned __int128 u128;

static inline u64 mix64(u64 x){ x^=x>>33; x*=0xff51afd7ed558ccdULL; x^=x>>33; x*=0xc4ceb9fe1a85ec53ULL; x^=x>>33; return x; }
static u64 hashBytes(const u8* d, int L){
  u64 h=0x9E3779B97F4A7C15ULL ^ (u64)L; int i=0;
  for(;i+8<=L;i+=8){ u64 v; memcpy(&v,d+i,8); h=mix64(h^v)+(u64)i; }
  u64 v=0; memcpy(&v,d+i,L-i); return mix64(h^v^((u64)(L-i)<<56));
}
static inline u64 hashWords(const u32* d,int K){ u64 h=0x1234567ULL; for(int i=0;i<K;i++) h=mix64(h^((u64)d[i]+((u64)i<<40))); return h; }

static const u32 EMPTY=0xFFFFFFFFu;

// ---------- thread-safe interning of byte vectors (columns, flag vectors); ids are exact ----------
struct Interner {
  int L; static const int SH=256; static const u32 BLK=1u<<16; static const int MAXBLK=1<<16;
  struct Shard { mutex m; vector<u8*> blocks; u32 cnt=0; vector<u32> tab; vector<u32> th; u32 mask=0; };
  Shard* sh;
  explicit Interner(int L_):L(L_){ sh=new Shard[SH]; for(int i=0;i<SH;i++){ sh[i].blocks.reserve(MAXBLK); sh[i].tab.assign(1024,EMPTY); sh[i].th.assign(1024,0); sh[i].mask=1023; } }
  inline const u8* get(u32 id) const { const Shard&s=sh[id&(SH-1)]; u32 li=id>>8; return s.blocks[li/BLK]+(size_t)(li%BLK)*L; }
  u32 intern(const u8* d){ return intern(d,hashBytes(d,L)); }
  u32 intern(const u8* d,u64 h){
    int si=(int)(h&(SH-1)); Shard&s=sh[si]; u32 hh=(u32)(h>>32);
    lock_guard<mutex> g(s.m);
    u32 pos=hh&s.mask;
    while(true){ u32 e=s.tab[pos]; if(e==EMPTY) break; if(s.th[pos]==hh && memcmp(get(e),d,L)==0) return e; pos=(pos+1)&s.mask; }
    u32 li=s.cnt++; if(li>=(1u<<24)-1){ fprintf(stderr,"interner overflow\n"); exit(3); }
    if(li/BLK>=s.blocks.size()) s.blocks.push_back((u8*)malloc((size_t)BLK*L));
    memcpy(s.blocks[li/BLK]+(size_t)(li%BLK)*L,d,L);
    u32 id=(li<<8)|(u32)si; s.tab[pos]=id; s.th[pos]=hh;
    if((u64)s.cnt*2 > (u64)s.mask+1){
      u32 nm=s.mask*2+1; vector<u32> nt(nm+1,EMPTY), nh(nm+1,0);
      for(u32 p=0;p<=s.mask;p++) if(s.tab[p]!=EMPTY){ u32 q=s.th[p]&nm; while(nt[q]!=EMPTY) q=(q+1)&nm; nt[q]=s.tab[p]; nh[q]=s.th[p]; }
      s.tab.swap(nt); s.th.swap(nh); s.mask=nm;
    }
    return id;
  }
  size_t size() const { size_t t=0; for(int i=0;i<SH;i++) t+=sh[i].cnt; return t; }
  // dump / reload in (shard, local index) order; reloading in this order recreates the same ids
  void dump(FILE* f) const { fwrite(&L,4,1,f); for(int i=0;i<SH;i++){ u32 c=sh[i].cnt; fwrite(&c,4,1,f); for(u32 li=0;li<c;li++) fwrite(get((li<<8)|(u32)i),1,L,f); } }
  void load(FILE* f){ int l; if(fread(&l,4,1,f)!=1||l!=L){ fprintf(stderr,"interner load: bad header\n"); exit(9); } vector<u8> b(L);
    for(int i=0;i<SH;i++){ u32 c; if(fread(&c,4,1,f)!=1) exit(9); for(u32 li=0;li<c;li++){ if(fread(b.data(),1,L,f)!=(size_t)L) exit(9);
        u32 id=intern(b.data()); if(id!=((li<<8)|(u32)i)){ fprintf(stderr,"interner load: id mismatch\n"); exit(9); } } } }
};

// ---------- open-addressing set of fixed-length u32 keys (one thread per shard) ----------
static int KS_LOAD=80; // max load factor in percent
struct KeySet {
  int K=0; vector<u32> tab; vector<u8> tg; u64 mask=0, cnt=0;   // tg = per-slot tag (layer number mod 256)
  void init(int K_, u64 cap){ K=K_; mask=cap-1; cnt=0; tab.assign(cap*K,EMPTY); tg.assign(cap,0); }
  bool insert(const u32* k, u64 h){ bool nw; findOrInsert(k,h,nw); return nw; }
  u64 findOrInsert(const u32* k, u64 h, bool& isNew){
    if((cnt+1)*100 > (mask+1)*KS_LOAD) grow();
    u64 p=h&mask;
    while(true){ u32* e=&tab[p*K]; if(e[0]==EMPTY){ memcpy(e,k,K*4); cnt++; isNew=true; return p; } if(memcmp(e,k,K*4)==0){ isNew=false; return p; } p=(p+1)&mask; }
  }
  void grow(){
    u64 nm=mask*2+1; vector<u32> nt((nm+1)*K,EMPTY); vector<u8> ng(nm+1,0);
    for(u64 p=0;p<=mask;p++){ const u32* e=&tab[p*K]; if(e[0]==EMPTY) continue; u64 q=hashWords(e,K)&nm; while(nt[q*K]!=EMPTY) q=(q+1)&nm; memcpy(&nt[q*K],e,K*4); ng[q]=tg[p]; }
    tab.swap(nt); tg.swap(ng); mask=nm;
  }
};
