# n=5 model=out iset=I1 prefix14_class=10962
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P0, P2
cmovle S2, P0
cmovg S2, P2
cmovg P2, P0
cmp P1, P3
cmovle P0, P3
