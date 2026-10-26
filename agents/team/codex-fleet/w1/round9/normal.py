def normalize_new_registers(s,editable,old,extra):
 """Give fresh names in order of first occurrence, destination before source."""
 prior=[]
 for t in sorted(editable):
  _,d,src=s.choice[t]
  for e in range(1,extra):
   seen=[v for pt in prior for v in (s.choice[pt][1][old+e-1],s.choice[pt][2][old+e-1])]
   s.add(-d[old+e],*seen)
   s.add(-src[old+e],d[old+e-1],*seen)
  prior.append(t)
