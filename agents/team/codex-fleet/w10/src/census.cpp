// Independent finite analysis of partial columns and guarded-write removal.
// Classifies 120 strict orders, or all 541 weak orders with -DCLASS_WEAK=1.
// Uses all 541 weak orders for value/flag liveness in both builds.
// This is a sample analyzer, not a substitute for shared/judge.py.
#include <bits/stdc++.h>
#include <zlib.h>
using namespace std;
static constexpr int R=40,W=541,U=255;
#ifndef CLASS_WEAK
#define CLASS_WEAK 0
#endif
static constexpr int CW=CLASS_WEAK?541:120;
enum {MOV,CMP,L,LE,G,GE,OUT};
struct Ins{int op,a,b;};
struct Detail{array<uint8_t,W>x,y,f,col;};
vector<array<int,5>> cases;
int expected[W][5];
int masks[W][6];
unordered_map<string,bool> cache;
map<string,long long> counts;
static bool cond(int op,int f){return op==L?f==1:op==LE?f!=2:op==G?f==2:f!=1;}
static bool lattice(const uint8_t* col,const uint8_t* needed=nullptr){
    string key(CW,'\0');
    for(int w=0;w<CW;w++)key[w]=(needed&&!needed[w])?U:col[w];
    auto it=cache.find(key);if(it!=cache.end())return it->second;
    int g[32];fill(g,g+32,-1);g[0]=0;g[31]=1;
    bool ok=true;
    for(int w=0;w<CW&&ok;w++)if((uint8_t)key[w]!=U){
        int v=(uint8_t)key[w];
        for(int k=0;k<=5;k++){
            int B=masks[w][k],b=(v>=5-k);
            if(g[B]>=0&&g[B]!=b){ok=false;break;}g[B]=b;
        }
    }
    if(ok)for(int a=0;a<32;a++)if(g[a]==1)
        for(int b=0;b<32;b++)if((a&b)==a&&g[b]==0)ok=false;
    if(cache.size()>200000)cache.clear();
    cache.emplace(move(key),ok);return ok;
}
struct Report{int partial=0,badpartial=0,nonlat=0;bool correct=true,unsupported=false;};
static Report run(const vector<Ins>& p,vector<Detail>*details=nullptr){
    uint8_t regs[R][W],f[W];memset(regs,U,sizeof(regs));memset(f,0,sizeof(f));
    for(int w=0;w<W;w++)for(int i=0;i<5;i++)regs[i][w]=cases[w][i];
    Report rep;int outseen=0;
    if(details)details->resize(p.size());
    for(int t=0;t<(int)p.size();t++){
        auto [op,a,b]=p[t];
        Detail* dt=details?&(*details)[t]:nullptr;
        if(dt){copy(regs[a],regs[a]+W,dt->x.begin());copy(regs[b],regs[b]+W,dt->y.begin());}
        if(op==OUT){
            outseen|=1<<a;
            for(int w=0;w<W;w++){
                if(regs[b][w]!=expected[w][a])rep.correct=false;
            }
        }else if(op==CMP){
            for(int w=0;w<W;w++){
                int x=regs[a][w],y=regs[b][w];
                if(x==U||y==U){rep.unsupported=true;return rep;}
                f[w]=x<y?1:x>y?2:0;
            }
        }else{
            for(int w=0;w<W;w++)if(op==MOV||cond(op,f[w]))regs[a][w]=regs[b][w];
            int garb=0;for(int w=0;w<CW;w++)garb+=regs[a][w]==U;
            if(garb&&garb<CW){rep.partial++;if(!lattice(regs[a]))rep.badpartial++;}
            if(!garb&&!lattice(regs[a]))rep.nonlat++;
        }
        if(dt){copy(f,f+W,dt->f.begin());copy(regs[a],regs[a]+W,dt->col.begin());}
    }
    if(outseen!=31)rep.unsupported=true;
    return rep;
}
static vector<Ins> movify(const vector<Ins>& p,const vector<Detail>& detail,int& badlive,int& changes){
    uint8_t live[R][W],flive[W];memset(live,0,sizeof(live));memset(flive,0,sizeof(flive));
    vector<Ins> q=p;int outseen=0;badlive=0;changes=0;
    for(int t=(int)p.size()-1;t>=0;t--){
        auto [op,a,b]=p[t];auto& dt=detail[t];
        if(op==OUT){if(!(outseen>>a&1)){memset(live[b],1,W);outseen|=1<<a;}continue;}
        if(op==CMP){
            for(int w=0;w<W;w++){live[a][w]|=flive[w];live[b][w]|=flive[w];flive[w]=0;}continue;
        }
        uint8_t needed[W];copy(live[a],live[a]+W,needed);memset(live[a],0,W);
        int garb=0;for(int w=0;w<CW;w++)garb+=dt.col[w]==U;
        if(garb&&garb<CW&&!lattice(dt.col.data(),needed))badlive++;
        bool safe=true;
        for(int w=0;w<W;w++)if(needed[w]){
            if(op==MOV||cond(op,dt.f[w]))live[b][w]=1;else live[a][w]=1;
            if(op!=MOV&&dt.x[w]!=dt.y[w])flive[w]=1;
            if(dt.y[w]!=dt.col[w])safe=false;
        }
        if(op!=MOV&&safe){q[t].op=MOV;changes++;}
    }
    return q;
}
static int regid(string s){return s[0]=='P'?stoi(s.substr(1)):5+stoi(s.substr(1));}
static string regname(int r){return r<5?"P"+to_string(r):"S"+to_string(r-5);}
static void save(const vector<Ins>& p,string name){
    static const char* ops[]={"mov","cmp","cmovl","cmovle","cmovg","cmovge","out"};
    ofstream f(name);f<<"# n=5 model=out iset=I1 source=w10_census\n";
    for(auto [op,a,b]:p)f<<ops[op]<<" "<<(op==OUT?to_string(a):regname(a))<<", "<<regname(b)<<"\n";
}
static void process(vector<Ins>& p,long index){
    vector<Detail> detail;Report before=run(p,&detail);counts["analyzed"]++;
    if(before.unsupported){counts["unsupported"]++;return;}
    int badlive,changes;auto q=movify(p,detail,badlive,changes);Report after=run(q);
    if(!before.correct)counts["original_wrong_541"]++;
    if(!after.correct)counts["normalized_wrong_541"]++;
    if(after.unsupported)counts["normalized_unsupported"]++;
    if(before.nonlat)counts["nonlattice_full_before"]++;
    if(!after.nonlat&&!after.partial)counts["all_pure_after"]++;
    if(before.nonlat&&!after.nonlat&&!after.partial)counts["nonlattice_full_before_pure_after"]++;
    if(before.partial){
        counts["with_partial"]++;
        if(before.badpartial)counts["noncompletable_partial"]++;
        if(badlive){
            counts["noncompletable_live_partial"]++;
            if(counts["noncompletable_live_partial"]<=4)save(p,"programs/live_obstacle_"+to_string(index)+".s");
        }
        if(!before.nonlat){
            counts["full_lattice_plus_partial"]++;
            if(after.nonlat||after.partial){
                counts["normalization_failure"]++;
                if(counts["normalization_failure"]<=8){
                    save(p,"programs/census_failure_"+to_string(index)+".s");
                    save(q,"programs/census_failure_"+to_string(index)+"_movified.s");
                }
            }else counts["normalization_success"]++;
        }
    }
}
int main(int argc,char**argv){
    if(argc<2)return 2;long limit=argc>2?stol(argv[2]):5000;
    double cpu_limit=argc>3?stod(argv[3]):1e30;clock_t start=clock();
    array<int,5>a={0,1,2,3,4};do{cases.push_back(a);}while(next_permutation(a.begin(),a.end()));
    for(int c=0;c<3125;c++){
        int x=c,used=0;for(int i=0;i<5;i++){a[i]=x%5;x/=5;used|=1<<a[i];}
        if((used&(used+1))==0&&used!=31)cases.push_back(a);
    }
    assert(cases.size()==W);
    for(int w=0;w<W;w++){
        auto sorted=cases[w];sort(sorted.begin(),sorted.end());
        copy(sorted.begin(),sorted.end(),expected[w]);
    }
    for(int w=0;w<W;w++)for(int k=0;k<=5;k++){
        masks[w][k]=0;for(int i=0;i<5;i++)if(cases[w][i]>=5-k)masks[w][k]|=1<<i;
    }
    gzFile f=gzopen(argv[1],"rb");if(!f)return 3;char line[2048];vector<Ins>p;long index=0;
    while(gzgets(f,line,sizeof(line))){
        if(line[0]=='#'){
            if(!p.empty()){
                process(p,index++);p.clear();
                if(index%100000==0)cerr<<"PROGRESS analyzed="<<index<<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<"\n";
                if(index>=limit||double(clock()-start)/CLOCKS_PER_SEC>=cpu_limit)break;
            }
            continue;
        }
        char op[32],a[32],b[32];if(sscanf(line," %31s %31[^, ] , %31s",op,a,b)!=3)continue;
        string s=op;int o=s=="mov"?MOV:s=="cmp"?CMP:s=="cmovl"?L:s=="cmovle"?LE:s=="cmovg"?G:s=="cmovge"?GE:s=="out"?OUT:-1;
        if(o<0){cerr<<"unsupported opcode\n";return 4;}
        int ra=o==OUT?stoi(a):regid(a),rb=regid(b);if(ra>=R||rb>=R)return 5;
        p.push_back({o,ra,rb});
    }
    if(!p.empty()&&index<limit)process(p,index++);
    counts["cpu_milliseconds"]=llround(1000.*double(clock()-start)/CLOCKS_PER_SEC);
    counts["reached_eof"]=gzeof(f)?1:0;
    gzclose(f);cout<<"{\n";bool first=true;
    for(auto [k,v]:counts){if(!first)cout<<",\n";first=false;cout<<"  \""<<k<<"\": "<<v;}
    cout<<"\n}\n";
}
