// Correct-network walk with time-and-wire reflection symmetry.
// A length-c comparator list obeys pair[c-1-i] = reflect(pair[i]).
// The compiler omits repeated CMOV results and allows any available register
// as the old destination or source of a CMOV, using all 541 weak orders.
#define main search_main
#include "search.cpp"
#undef main
#include <unordered_map>
#include <unordered_set>
#include <queue>
using Pair=pair<int,int>;
vector<Pair> pairs;
Pair reflected(Pair a){return {4-a.second,4-a.first};}
bool sortednet(const vector<Pair>&p){
  uint32_t r[5]={0xaaaaaaaa,0xcccccccc,0xf0f0f0f0,0xff00ff00,0xffff0000};
  for(auto [a,b]:p){auto x=r[a],y=r[b];r[a]=x&y;r[b]=x|y;}
  for(int i=0;i<4;i++)if(r[i]&~r[i+1])return false;return true;
}
string nethash(const vector<Pair>&p){string s;for(auto[a,b]:p)s.push_back(a*5+b);return s;}
using Val=array<uint8_t,541>;
struct Block {int a,b;vector<int> targets;array<array<uint64_t,4>,32> match;};
struct Circuit{vector<Val>terms;vector<Block>blocks;array<int,5>outs;int lastuse[32];int gates;};
Circuit circuit(const vector<Pair>&net){
  Circuit c;int wires[5];vector<int>producer;vector<array<int,4>>raw;
  auto intern=[&](const Val&v,int prod){for(int i=0;i<(int)c.terms.size();i++)if(c.terms[i]==v)return i;c.terms.push_back(v);producer.push_back(prod);return (int)c.terms.size()-1;};
  for(int i=0;i<5;i++){Val v;for(int t=0;t<541;t++)v[t]=orders[t][i];wires[i]=intern(v,-1);}
  for(int i=0;i<(int)net.size();i++){
    auto[a,b]=net[i];int x=wires[a],y=wires[b];Val mn,mx;
    for(int t=0;t<541;t++){mn[t]=min(c.terms[x][t],c.terms[y][t]);mx[t]=max(c.terms[x][t],c.terms[y][t]);}
    int lo=intern(mn,i),hi=intern(mx,i);raw.push_back({x,y,lo,hi});wires[a]=lo;wires[b]=hi;
  }
  if(c.terms.size()>32)abort();
  uint64_t needed=0;vector<bool>active(net.size());
  function<void(int)>require=[&](int v){if(needed>>v&1)return;needed|=1ULL<<v;int p=producer[v];if(p>=0){active[p]=true;require(raw[p][0]);require(raw[p][1]);}};
  for(int j=0;j<5;j++){c.outs[j]=wires[j];require(wires[j]);}
  fill(c.lastuse,c.lastuse+32,-1);c.gates=0;
  for(int i=0;i<(int)net.size();i++)if(active[i]){
    Block b{};b.a=raw[i][0];b.b=raw[i][1];
    for(int v:{raw[i][2],raw[i][3]})if((needed>>v&1)&&producer[v]==i)b.targets.push_back(v);
    int k=c.blocks.size();c.lastuse[b.a]=c.lastuse[b.b]=k;c.gates+=b.targets.size();c.blocks.push_back(b);
  }
  // match[v][cond] lists terms that equal v in cases where cond holds.
  for(auto&b:c.blocks)for(int v=0;v<(int)c.terms.size();v++)for(int cond=0;cond<4;cond++){
    uint64_t m=0;
    for(int w=0;w<(int)c.terms.size();w++){
      bool ok=true;
      for(int t=0;t<541;t++){
        int a=c.terms[b.a][t],z=c.terms[b.b][t];bool use=cond==0?a<z:cond==1?a<=z:cond==2?a>z:a>=z;
        if(use&&c.terms[v][t]!=c.terms[w][t]){ok=false;break;}
      }
      if(ok)m|=1ULL<<w;
    }
    b.match[v][cond]=m;
  }
  return c;
}
struct Route {uint64_t avail;int cost,nextreg;array<int,32>reg;Prog p;};
struct Compiled {int cost;Prog p;size_t peak;};
Compiled compile(const Circuit&c,int limit){
  int lower=c.blocks.size()+c.gates;
  if(lower>limit)return {999,{},0};
  Route initial{};initial.avail=31;initial.nextreg=5;initial.reg.fill(-1);for(int i=0;i<5;i++)initial.reg[i]=i;
  vector<Route>states={initial};size_t peak=1;
  for(int bi=0;bi<(int)c.blocks.size();bi++){
    auto&b=c.blocks[bi];unordered_map<uint64_t,Route> next;
    for(auto st:states){
      if(!(st.avail>>b.a&1)||!(st.avail>>b.b&1))continue;
      st.p.push_back({CMP,st.reg[b.a],st.reg[b.b]});st.cost++;
      auto targets=b.targets;sort(targets.begin(),targets.end());
      do{
        vector<Route>partial={st};
        for(int v:targets){
          vector<Route>updated;
          for(auto&r:partial){
            if(r.avail>>v&1){updated.push_back(r);continue;}
            for(int cond=0;cond<4;cond++){
              uint64_t srcs=b.match[v][cond]&r.avail;
              if(!srcs)continue;int src=__builtin_ctzll(srcs);
              // Complement of l/le/g/ge is ge/g/le/l, respectively.
              uint64_t dsts=b.match[v][3-cond]&r.avail;
              if(!dsts)continue;
              int op=cond==0?L:cond==1?LE:cond==2?G:GE;
              for(uint64_t m=dsts;m;m&=m-1){
                int d=__builtin_ctzll(m);if(c.lastuse[d]>bi)continue;
                Route q=r;q.cost++;q.avail=(q.avail&~(1ULL<<d))|(1ULL<<v);q.reg[v]=q.reg[d];q.reg[d]=-1;
                q.p.push_back({op,q.reg[v],r.reg[src]});updated.push_back(move(q));
              }
              // Copy a matching old destination, then perform the CMOV.
              Route q=r;int d=__builtin_ctzll(dsts);int reg=q.nextreg++;
              if(reg>=NR)continue;q.cost+=2;q.avail|=1ULL<<v;q.reg[v]=reg;
              q.p.push_back({MOV,reg,r.reg[d]});q.p.push_back({op,reg,r.reg[src]});updated.push_back(move(q));
            }
          }
          unordered_map<uint64_t,Route>unique;
          for(auto&q:updated){
            // Every as-yet unbuilt required term needs at least one CMOV.
            int remaining=c.gates; // Tightened below after this block.
            (void)remaining;
            if(q.cost>limit)continue;
            auto it=unique.find(q.avail);if(it==unique.end()||it->second.cost>q.cost)unique[q.avail]=move(q);
          }
          partial.clear();for(auto&[key,q]:unique)partial.push_back(move(q));
        }
        for(auto&q:partial){auto it=next.find(q.avail);if(it==next.end()||it->second.cost>q.cost)next[q.avail]=move(q);}
      }while(next_permutation(targets.begin(),targets.end()));
    }
    int remcmp=c.blocks.size()-bi-1,remgate=0;for(int j=bi+1;j<(int)c.blocks.size();j++)remgate+=c.blocks[j].targets.size();
    states.clear();for(auto&[key,q]:next)if(q.cost+remcmp+remgate<=limit)states.push_back(move(q));
    peak=max(peak,states.size());if(states.empty())return {999,{},peak};
  }
  auto it=min_element(states.begin(),states.end(),[](auto&a,auto&b){return a.cost<b.cost;});
  return {it->cost,it->p,peak};
}
uint64_t delayed_nodes=0,delayed_cutoffs=0;
Compiled compile_delayed(const Circuit&c,int limit,uint64_t cap=1000000,bool optional=false){
  uint32_t required=31;for(auto&b:c.blocks)required|=(1u<<b.a)|(1u<<b.b);for(int v:c.outs)required|=1u<<v;
  int ng=__builtin_popcount(required)-5;
  if((int)c.blocks.size()+ng>limit)return {999,{},0};
  struct Entry {Route route;uint32_t done;};
  Entry start{};start.route.avail=31;start.route.nextreg=5;start.route.reg.fill(-1);start.done=31;
  for(int i=0;i<5;i++)start.route.reg[i]=i;
  vector<Entry>states={start};size_t peak=1;uint64_t nodes=0;
  uint32_t goalmask=0;for(int v:c.outs)goalmask|=1u<<v;
  for(int bi=0;bi<(int)c.blocks.size();bi++){
    auto&b=c.blocks[bi];unordered_map<uint64_t,Entry>closure;
    queue<uint64_t>todo;
    auto push=[&](Entry&&e){
      int rem=c.blocks.size()-bi-1+__builtin_popcount(required&~e.done);
      if(e.route.cost+rem>limit)return;
      uint64_t key=((uint64_t)e.done<<32)|e.route.avail;
      auto it=closure.find(key);if(it==closure.end()||it->second.route.cost>e.route.cost){closure[key]=move(e);todo.push(key);}
    };
    for(auto&e:states){
      auto&r=e.route;if(!(r.avail>>b.a&1)||!(r.avail>>b.b&1))continue;
      r.p.push_back({CMP,r.reg[b.a],r.reg[b.b]});r.cost++;push(move(e));
    }
    while(!todo.empty()){
      uint64_t key=todo.front();todo.pop();Entry e=closure.at(key);
      if(bi==(int)c.blocks.size()-1&&(e.done&goalmask)==goalmask){delayed_nodes+=nodes;return {e.route.cost,e.route.p,max(peak,closure.size())};}
      if(++nodes>cap){delayed_nodes+=nodes;delayed_cutoffs++;return {998,{},max(peak,closure.size())};}
      if(closure.size()>250000){delayed_nodes+=nodes;delayed_cutoffs++;return {998,{},max(peak,closure.size())};}
      auto&r=e.route;
      uint32_t palette=optional?uint32_t((1ULL<<c.terms.size())-1):required;
      for(uint32_t pending=palette&~e.done;pending;pending&=pending-1){
        int v=__builtin_ctz(pending);
        for(int cond=0;cond<4;cond++){
          uint64_t srcs=b.match[v][cond]&r.avail;if(!srcs)continue;int src=__builtin_ctzll(srcs);
          uint64_t dsts=b.match[v][3-cond]&r.avail;if(!dsts)continue;
          int op=cond==0?L:cond==1?LE:cond==2?G:GE;
          for(uint64_t m=dsts;m;m&=m-1){
            int d=__builtin_ctzll(m);if(c.lastuse[d]>bi)continue;
            Entry q=e;q.done|=1u<<v;auto&z=q.route;z.cost++;
            z.avail=(z.avail&~(1ULL<<d))|(1ULL<<v);z.reg[v]=z.reg[d];z.reg[d]=-1;
            z.p.push_back({op,z.reg[v],r.reg[src]});push(move(q));
          }
          Entry q=e;q.done|=1u<<v;auto&z=q.route;int d=__builtin_ctzll(dsts);int reg=z.nextreg++;
          if(reg>=NR)continue;z.cost+=2;z.avail|=1ULL<<v;z.reg[v]=reg;
          z.p.push_back({MOV,reg,r.reg[d]});z.p.push_back({op,reg,r.reg[src]});push(move(q));
        }
      }
    }
    peak=max(peak,closure.size());states.clear();
    for(auto&[key,e]:closure)states.push_back(move(e));
    if(states.empty()){delayed_nodes+=nodes;return {999,{},peak};}
  }
  delayed_nodes+=nodes;int best=999;Prog answer;
  uint32_t outmask=0;for(int v:c.outs)outmask|=1u<<v;
  for(auto&e:states)if((e.done&outmask)==outmask&&e.route.cost<best){best=e.route.cost;answer=e.route.p;}
  return {best,answer,peak};
}
Circuit from_program(const Prog&p){
  Circuit c;Val r[NR];uint8_t flags[541];fill(flags,flags+541,3);
  auto intern=[&](const Val&v){for(auto x:v)if(x==7)return -1;for(int i=0;i<(int)c.terms.size();i++)if(c.terms[i]==v)return i;c.terms.push_back(v);if(c.terms.size()>32)abort();return int(c.terms.size())-1;};
  for(int i=0;i<NR;i++){for(int t=0;t<541;t++)r[i][t]=i<5?orders[t][i]:7;if(i<5)intern(r[i]);}
  for(auto x:p){
    if(x.o==CMP){
      Block b{};b.a=intern(r[x.d]);b.b=intern(r[x.s]);if(b.a<0||b.b<0)abort();c.blocks.push_back(b);
      for(int t=0;t<541;t++)flags[t]=r[x.d][t]<r[x.s][t]?1:r[x.d][t]>r[x.s][t]?2:0;
    }else{
      if(x.o==MOV)r[x.d]=r[x.s];
      else for(int t=0;t<541;t++){
        int f=flags[t];bool use=(x.o==L&&f==1)||(x.o==LE&&f!=2)||(x.o==G&&f==2)||(x.o==GE&&f!=1);
        if(f==3){if(r[x.d][t]!=r[x.s][t])r[x.d][t]=7;}else if(use)r[x.d][t]=r[x.s][t];
      }
      intern(r[x.d]);
    }
  }
  for(int j=0;j<5;j++){Val v;for(int t=0;t<541;t++){auto a=orders[t];sort(a.begin(),a.end());v[t]=a[j];}c.outs[j]=intern(v);}
  fill(c.lastuse,c.lastuse+32,-1);
  for(int bi=0;bi<(int)c.blocks.size();bi++){
    auto&b=c.blocks[bi];c.lastuse[b.a]=c.lastuse[b.b]=bi;
    for(int v=0;v<(int)c.terms.size();v++)for(int cond=0;cond<4;cond++){
      uint64_t mask=0;
      for(int w=0;w<(int)c.terms.size();w++){
        bool ok=true;
        for(int t=0;t<541;t++){
          int a=c.terms[b.a][t],z=c.terms[b.b][t];bool use=cond==0?a<z:cond==1?a<=z:cond==2?a>z:a>=z;
          if(use&&c.terms[v][t]!=c.terms[w][t]){ok=false;break;}
        }
        if(ok)mask|=1ULL<<w;
      }
      b.match[v][cond]=mask;
    }
  }
  return c;
}
// Signature includes value terms and comparison order, not physical registers.
uint64_t circhash(const Circuit&c){uint64_t h=1469598103934665603ULL;for(auto&b:c.blocks){for(int v:{b.a,b.b})for(auto x:c.terms[v])h=(h^x)*1099511628211ULL;}return h;}
int main(int argc,char**argv){
  if(argc>1&&string(argv[1])=="route"){
    init();Prog p=read(argv[2]);auto c=from_program(p);int limit=atoi(argv[3]);uint64_t cap=argc>5?strtoull(argv[5],0,10):1000000;
    auto r=compile_delayed(c,limit,cap,true);
    printf("ROUTE cost=%d blocks=%zu pool=%zu nodes=%llu cutoffs=%llu peak=%zu\n",r.cost,c.blocks.size(),c.terms.size(),(unsigned long long)delayed_nodes,(unsigned long long)delayed_cutoffs,r.peak);
    if(r.cost<998){if(!fullcheck(r.p).ok)abort();save(r.p,argv[4]);printf("CANDIDATE file=%s\n",argv[4]);}
    return 0;
  }
  int count=argc>1?atoi(argv[1]):10;double seconds=argc>2?atof(argv[2]):600;uint64_t seed=argc>3?strtoull(argv[3],0,10):555;
  string prefix=argc>4?argv[4]:"candidates/mirror";int limit=argc>5?atoi(argv[5]):31;bool delayed=argc>6&&atoi(argv[6]);
  init();rng.seed(seed);for(int a=0;a<5;a++)for(int b=a+1;b<5;b++)pairs.push_back({a,b});
  int half=count/2;vector<Pair>net(count);uint64_t proposals=0,correct=0,unique=0,circuits=0,compiled=0;int best=999;
  unordered_set<string>seen;unordered_set<uint64_t>cseen;
  auto start=chrono::steady_clock::now();bool have=false;
  while(chrono::duration<double>(chrono::steady_clock::now()-start).count()<seconds){
    vector<Pair>q=net;
    if(!have||rng()%1000==0){for(int i=0;i<half;i++)q[i]=pairs[rng()%pairs.size()];if(count%2)q[half]=(rng()&1)?Pair{0,4}:Pair{1,3};}
    else{
      int i=rng()%(half+(count%2));
      if(i==half)q[i]=q[i]==Pair{0,4}?Pair{1,3}:Pair{0,4};
      else q[i]=pairs[rng()%pairs.size()];
      if(rng()%5==0){int j=rng()%half;q[j]=pairs[rng()%pairs.size()];}
    }
    for(int i=0;i<half;i++)q[count-1-i]=reflected(q[i]);
    proposals++;if(!sortednet(q))continue;correct++;net=q;have=true;
    if(!seen.insert(nethash(net)).second)continue;unique++;
    auto c=circuit(net);if(!cseen.insert(circhash(c)).second)continue;circuits++;
    auto result=delayed?compile_delayed(c,limit):compile(c,limit);compiled++;
    if(result.cost==998)continue;
    if(result.cost<best){
      best=result.cost;
      if(best<999){if(!fullcheck(result.p).ok){fprintf(stderr,"compiler failure\n");return 4;}
        string fn=prefix+"_k"+to_string(best)+".s";save(result.p,fn);
        printf("MIRROR_CANDIDATE k=%d count=%d blocks=%zu gates=%d file=%s\n",best,count,c.blocks.size(),c.gates,fn.c_str());fflush(stdout);
      }
    }
    if(unique%100==0){printf("MIRROR unique=%llu circuits=%llu proposals=%llu\n",(unsigned long long)unique,(unsigned long long)circuits,(unsigned long long)proposals);fflush(stdout);}
  }
  printf("MIRROR_DONE c=%d limit=%d proposals=%llu correct=%llu unique=%llu circuits=%llu compiled=%llu best=%d seconds=%.3f\n",count,limit,(unsigned long long)proposals,(unsigned long long)correct,(unsigned long long)unique,(unsigned long long)circuits,(unsigned long long)compiled,best,chrono::duration<double>(chrono::steady_clock::now()-start).count());
  printf("DELAYED nodes=%llu cutoffs=%llu\n",(unsigned long long)delayed_nodes,(unsigned long long)delayed_cutoffs);
}
