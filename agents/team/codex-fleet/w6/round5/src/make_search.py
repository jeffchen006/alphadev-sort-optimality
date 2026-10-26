from pathlib import Path
s=Path('round2/src/novelty.cpp').read_text()
s=s.replace('#include "../../src/local.cpp"','#include "../../src/local.cpp"')
a=s.index('  for(auto entry:filesystem::directory_iterator("verified"))')
b=s.index('  vector<array<int,5>>all,sub;',a)
s=s[:a]+'  archive.push_back(start);\n'+s[b:]
s=s.replace('if((int)start.size()>slots){','while((int)start.size()>slots){')
s=s.replace('  if(!fullcheck(start)){cerr<<"seed is not correct on independent evaluator\\n";return 2;}','  cerr<<"New-algorithm search. The seed may fail.\\n";')
s=s.replace('if(nc>maxcmp||nc<7)continue;','if(nc>maxcmp||nc<8)continue;')
s=s.replace('if(e<besterr){besterr=e;','if(e<besterr){if(archive.size()<100)archive.push_back(cur);besterr=e;')
s=s.replace('while((int)start.size()>slots)start.erase(start.begin()+rng()%start.size());','''while((int)start.size()>slots){
        int be=99999;vector<I> bp;
        for(int pos=0;pos<(int)start.size();pos++){
          auto q=start;q.erase(q.begin()+pos);Snap test=initial;
          for(auto in:q)if(in.o>=0)step(test,in);
          int error=cost(test);if(error<be)be=error,bp=q;
        }
        start=bp;
      }''')
# Explicitly retain the source and flag phase structure in most comparison edits.
s=s.replace('else if(mv<96) {prop[a]=randins();prop[b]=randins();lo=min(a,b);}','''else if(mv<96) {
      // Select a new flag source and transfer one or two values under that flag.
      vector<int> cmps;for(int t=0;t<slots;t++)if(prop[t].o==CMP)cmps.push_back(t);
      if(cmps.empty())continue;a=cmps[rng()%cmps.size()];lo=a;
      prop[a].d=rng()%nr;prop[a].s=rng()%nr;
      int end=a+1;while(end<slots&&prop[end].o!=CMP)end++;
      for(int t=a+1;t<end;t++)if(rng()%2){prop[t]=randins();if(prop[t].o==CMP)prop[t].o=L+rng()%4;}
    }''')
s=s.replace('if(nc>maxcmp||nc<8)continue;', 'if(nc>maxcmp||nc<(argc>10?atoi(argv[10]):8))continue;')
Path('round5/src/new_search.cpp').write_text(s)
