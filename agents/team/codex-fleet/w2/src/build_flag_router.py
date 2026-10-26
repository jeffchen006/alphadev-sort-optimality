#!/usr/bin/env python3
"""Extend dagx alternative operands to equivalent conditional predicates.

Two compares can differ in lt/eq/gt outcomes but give the same set of
conditional move masks. Example: a:b and min(a,b):b on distinct a,b.
The emitted opcode is remapped separately for the selected operand pair.
"""
from pathlib import Path
s = Path('src/dagx.cpp').read_text()
s = s.replace('static vector<vector<Col>> COMMON;',
'''static vector<vector<array<int,4>>> ALTCD;
static int altSelected[16];
static vector<vector<Col>> COMMON;''')
s = s.replace('CN[nd.cond], r.c_str()',
              'CN[ALTCD[j-1][altSelected[j]][nd.cond]], r.c_str()')
s = s.replace('for (auto& [ca, cb] : ALT[j - 1]) {',
'''for (int ai=0; ai<(int)ALT[j-1].size(); ai++) {
      altSelected[j]=ai;
      auto& [ca, cb] = ALT[j-1][ai];''')
start = s.index('    ALT.push_back({});')
end = s.index('    for (int t = 0; t < NT; t++) { int va = evf(sk[j].first, TY[t]), vb = evf(sk[j].second, TY[t]); F[j + 1]',start)
s = s[:start]+'''    ALT.push_back({}); ALTCD.push_back({});
    auto take = [](int f,int cd) {
      return cd==0 ? f<0 : cd==1 ? f>0 : cd==2 ? f<=0 : f>=0;
    };
    vector<int> ref(NT);
    for(int t=0;t<NT;t++) {
      int va=evf(sk[j].first,TY[t]),vb=evf(sk[j].second,TY[t]);
      ref[t]=(va>vb)-(va<vb);
    }
    for(auto& [fa,fb]:skalt[j]) {
      Col x=mk([&](int t){return evf(fa,TY[t]);});
      Col y=mk([&](int t){return evf(fb,TY[t]);});
      vector<int> af(NT);
      for(int t=0;t<NT;t++) {
        int va=evf(fa,TY[t]),vb=evf(fb,TY[t]);
        af[t]=(va>vb)-(va<vb);
      }
      array<int,4> mp;
      for(int cd=0;cd<4;cd++) {
        bool first=take(ref[0],cd),constant=true;
        for(int t=1;t<NT;t++)
          if(take(ref[t],cd)!=first) {constant=false;break;}
        // Constant predicates cannot split a routing requirement, so
        // dagx never creates a gate with such a predicate.
        if(constant) {mp[cd]=0;continue;}
        mp[cd]=-1;
        for(int ac=0;ac<4;ac++) {
          bool ok=true;
          for(int t=0;t<NT;t++)
            if(take(ref[t],cd)!=take(af[t],ac)) {ok=false;break;}
          if(ok) {mp[cd]=ac;break;}
        }
        if(mp[cd]<0) {
          fprintf(stderr,"alternative %s:%s of cmp %d has other predicates\\n",
                  fa.c_str(),fb.c_str(),j+1);return 1;
        }
      }
      ALT.back().push_back({x,y}); ALTCD.back().push_back(mp);
    }
''' + s[end:]
Path('src/dagx_flags.cpp').write_text(s)
