from pathlib import Path
D=Path(__file__).resolve().parent;root=D.parents[1]
s=(root/'pool_bfs.cpp').read_text()
old='  St s0; memset(&s0, 255, sizeof s0);'
new=r'''
  // Necessary liveness condition, checked on all distinct-input cases.
  // A rank not yet emitted must occur in a current register on every case.
  // Neither cmp nor a later copy/select can restore a lost value.
  vector<int> strictcases;
  for (int t=0;t<NT;t++) { set<u8> v;for(int j=0;j<5;j++)v.insert(col[j][t]);if(v.size()==5)strictcases.push_back(t); }
  const int NW=(strictcases.size()+63)/64;
  vector<vector<vector<uint64_t>>> cov(NP,vector<vector<uint64_t>>(5,vector<uint64_t>(NW)));
  vector<uint64_t> full(NW,~0ULL);if(strictcases.size()%64)full.back()=(1ULL<<(strictcases.size()%64))-1;
  for(int p=0;p<NP;p++)for(int j=0;j<5;j++)for(int k=0;k<(int)strictcases.size();k++)
    if(col[p][strictcases[k]]==j)cov[p][j][k/64]|=1ULL<<(k%64);
  unordered_map<uint32_t,u8> alivecache;
  auto alive = [&](const St &s) {
    uint32_t have=0;for(int i=0;i<R;i++)if(s.r[i]!=255)have|=1u<<s.r[i];
    u8 ok=0;auto it=alivecache.find(have);
    if(it!=alivecache.end())ok=it->second;
    else {
      for(int j=0;j<5;j++) {
        bool good=true;
        for(int k=0;k<NW;k++) {
          uint64_t u=0;uint32_t m=have;
          while(m){int p=__builtin_ctz(m);m&=m-1;u|=cov[p][j][k];}
          if(u!=full[k]){good=false;break;}
        }
        if(good)ok|=1<<j;
      }
      alivecache[have]=ok;
    }
    for(int j=0;j<5;j++)if(!(ok>>j&1) && !(s.mask&bit(outterm[j])))return false;
    return true;
  };
  St s0; memset(&s0, 255, sizeof s0);'''
assert old in s;s=s.replace(old,new)
old='      norm(s); addmask(s);';assert old in s;s=s.replace(old,old+'\n      if (!alive(s)) return;')
(D/'pool_bfs_live.cpp').write_text(s)
