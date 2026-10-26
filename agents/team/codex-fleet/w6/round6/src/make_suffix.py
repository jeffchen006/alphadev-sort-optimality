from pathlib import Path
s=Path('round5/src/union.cpp').read_text()
s=s.replace('int nr;','int nr;\nint fixed_prefix;\nint retained;\nset<uint64_t> near_signatures;')
s=s.replace('nr=used+1;','nr=used+1;fixed_prefix=argc>11?atoi(argv[11]):19;')
s=s.replace('int a=rng()%slots,b=rng()%slots,lo=a,mv=rng()%100;', 'int a=fixed_prefix+rng()%(slots-fixed_prefix),b=fixed_prefix+rng()%(slots-fixed_prefix),lo=a,mv=rng()%100;')
s=s.replace('for(int t=0;t<slots;t++)if(prop[t].o==CMP)', 'for(int t=fixed_prefix;t<slots;t++)if(prop[t].o==CMP)')
s=s.replace('for(int j=0;j<slots;j++)if(prop[j].o==CMP)', 'for(int j=fixed_prefix;j<slots;j++)if(prop[j].o==CMP)')
# The prefix is fixed. A restart never introduces a seed longer than 31.
s=s.replace('if(e<besterr ||', 'if(e<besterr ||')
needle='cur=prop;cc=pc;accepted++;build(lo);'
s=s.replace(needle,needle+'''if(weakfail(snap[slots])<=10 && retained<128){
       auto sig=signature(cur);
       if(near_signatures.insert(sig).second){retained++;emitnear(cur,prefix+"_retained_"+to_string(retained)+".s");}
    }''')
s=s.replace('newstructures="<<newstructures','retained="<<retained<<" newstructures="<<newstructures')
Path('round6/src/suffix.cpp').write_text(s)
