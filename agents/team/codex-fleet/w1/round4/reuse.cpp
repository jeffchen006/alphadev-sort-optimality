// Reuse the validated masked-column engine. This driver defines a new family.
#define main round3_main
#include "../round3/reuse.cpp"
#undef main

int main(int argc,char**argv){
 string input=argc>1?argv[1]:"round4/problems.txt";
 int first=argc>2?atoi(argv[2]):144,last=argc>3?atoi(argv[3]):170;
 int testfirst=argc>4?atoi(argv[4]):0,testlast=argc>5?atoi(argv[5]):10000;
 double seconds=argc>6?atof(argv[6]):2;
 string prefix=argc>7?argv[7]:"round4/reuse";
 int cap=argc>8?atoi(argv[8]):31;
 bool freeComparisons=argc>9?atoi(argv[9]):true;
 bool copyOnly=argc>10?atoi(argv[10]):false;
 bool retainLive=argc>11?atoi(argv[11]):false;
 rlimit memory{2800ULL*1024*1024,2800ULL*1024*1024};
 setrlimit(RLIMIT_AS,&memory);
 ifstream f(input);int np;f>>np;
 for(int i=0;i<np;i++){
  Problem original=readproblem(f);if(i<first||i>=last)continue;
  vector<int>writes;int lastComparison=-1;
  for(int j=0;j<(int)original.ev.size();j++){
   const auto&e=original.ev[j];if(e.op==1){lastComparison=j;continue;}
   bool copy=e.op==0;
   if(e.op>=2){copy=true;for(int w=0;w<W;w++)if(e.need[w]&~original.ev[lastComparison].expected[e.op-2][w])copy=false;}
   if(!copyOnly||copy)writes.push_back(j);
  }
  int test=0;
  for(int a:writes)for(int b:writes){
   if(a==b)continue;
   int current=test++;if(current<testfirst||current>=testlast)continue;
   Problem p=original;
   // Delete b. Replace a by an arbitrary register write. Keep other creation masks.
   p.ev[b].deleted=true;p.ev[a].need={};
   // Comparisons and output times are free. Intermediate creation masks remain.
   if(freeComparisons)for(auto&e:p.ev)if(e.op==1)e.cmask={};
   for(auto&live:p.live){
    if(!retainLive)live.clear();
    else live.erase(remove_if(live.begin(),live.end(),[&](Need n){return n.col==p.ev[a].target||n.col==p.ev[b].target;}),live.end());
   }
   string stem=prefix+"_a"+to_string(a)+"_b"+to_string(b);
   double started=cpu();bool yes=false,limited=false;uint64_t kept=0,generated=0,candidates=0;
   int peak=0,columns=0;string error;
   try {
    Search s(p,cap,0,36,100000);
    s.early=true;s.secondsLimit=seconds;
    cout.setstate(ios_base::failbit);
    yes=s.solve(stem);
    cout.clear();limited=s.limited;kept=s.kept;generated=s.generated;
    peak=s.peak;columns=s.cols.size();candidates=s.candidates;
   }catch(const bad_alloc&){cout.clear();limited=true;error="memory";}
   cout<<"RESULT index="<<i<<" name="<<p.name<<" test="<<current<<" replace="<<a<<" delete="<<b<<" freecmp="<<freeComparisons<<" copies="<<copyOnly<<" hold="<<retainLive
       <<" status="<<(yes?"CANDIDATE":limited?"LIMIT":"NONE")<<" generated="<<generated
       <<" kept="<<kept<<" peak="<<peak<<" columns="<<columns<<" write_candidates="<<candidates
       <<" cpu="<<cpu()-started<<" error="<<error<<"\n";
   cout.flush();
   if(yes){string path=stem+"_"+p.name+".s";ifstream candidate(path);string line;int actual=0;
    while(getline(candidate,line)){istringstream row(line);string opcode;row>>opcode;if(!opcode.empty()&&opcode[0]!='#'&&opcode!="out")actual++;}
    cout<<"CANDIDATE file="<<path<<" k="<<actual<<"\n";return 0;}
  }
 }
}
