"""Three-bit rank values, cached gates, and constant-folded fixed instructions.

Inputs are ranks 0..4. Scratch starts at rank 5. Initial flags are equality.
This is a necessary concrete state for strict correctness, not strict semantics.
"""
from encode import Enc


class BinaryEnc(Enc):
    def configure(self,program,domains,destinations,sources):
        self.program=program;self.domains=domains
        self.destinations=destinations;self.sources=sources
        self.cache={}
        self.boolean_collision_hits=0

    def and_(self,*xs):
        if any(x is False for x in xs):return False
        xs=sorted(set(x for x in xs if x is not True))
        if not xs:return True
        if len(xs)==1:return xs[0]
        if any(-x in xs for x in xs):return False
        key=('and',*xs)
        if key not in self.cache:
            z=self.new()
            for x in xs:self.cl(-z,x)
            self.cl(z,*[-x for x in xs])
            self.cache[key]=z
        return self.cache[key]

    def or_(self,*xs):return self.neg(self.and_(*[self.neg(x) for x in xs]))

    def mux(self,c,a,b):
        if c is True:return a
        if c is False:return b
        if a==b:
            if type(a) is type(b):return a
            self.boolean_collision_hits+=1
        if a is True and b is False:return c
        if a is False and b is True:return -c
        if a is True:return self.or_(c,b)
        if a is False:return self.and_(-c,b)
        if b is True:return self.or_(-c,a)
        if b is False:return self.and_(c,a)
        key=('mux',c,a,b)
        if key not in self.cache:
            z=self.new()
            self.cl(-c,-a,z);self.cl(-c,a,-z)
            self.cl(c,-b,z);self.cl(c,b,-z)
            self.cache[key]=z
        return self.cache[key]

    def lt(self,a,b):
        lt=False;eq=True
        for bit in (2,1,0):
            lt=self.or_(lt,self.and_(eq,self.neg(a[bit]),b[bit]))
            eq=self.and_(eq,self.mux(a[bit],b[bit],self.neg(b[bit])))
        return lt

    def add_type(self,ranks):
        val=[tuple(bool((ranks[r] if r<5 else 5)&(1<<b)) for b in range(3)) for r in range(self.R)]
        lt=gt=False;nvs=[]
        trace=[]
        for i in range(self.k):
            domain=self.domains[i]
            def select(row,fixed):
                if fixed is not None:return val[fixed]
                return tuple(self.or_(*[self.and_(row[r],val[r][b]) for r in range(self.R)]) for b in range(3))
            dv=select(self.d[i],self.destinations[i]);sv=select(self.s[i],self.sources[i])
            if domain==['cmp']:
                nv=dv
            else:
                conditions={'mov':True,'cmp':False,'cmovl':lt,'cmovle':self.neg(gt),'cmovg':gt,'cmovge':self.neg(lt)}
                wr=conditions[domain[0]] if len(domain)==1 else self.or_(*[self.and_(self.op[i][o],conditions[o]) for o in domain])
                nv=tuple(self.mux(wr,sv[b],dv[b]) for b in range(3))
                fixed=self.destinations[i]
                if fixed is not None:
                    val=list(val);val[fixed]=nv
                else:
                    val=[tuple(self.mux(self.d[i][r],nv[b],val[r][b]) for b in range(3)) for r in range(self.R)]
            nvs.append(nv)
            if 'cmp' in domain and i+1<self.k:
                nlt=self.lt(dv,sv);ngt=self.lt(sv,dv)
                if domain==['cmp']:lt,gt=nlt,ngt
                else:lt=self.mux(self.op[i]['cmp'],nlt,lt);gt=self.mux(self.op[i]['cmp'],ngt,gt)
            trace.append((val,lt,gt))
        if getattr(self,'check_only',False):
            self.last_trace=trace
            self.types.append(tuple(ranks))
            return
        for j,goal in enumerate(sorted(ranks)):
            for r in range(5):
                if ranks[r]!=goal:self.cl(-self.osnap[j][r])
            for i,nv in enumerate(nvs):
                for b in range(3):self.cl(-self.osnap[j][5+i],nv[b] if goal&(1<<b) else self.neg(nv[b]))
        self.types.append(tuple(ranks))
