# n=5 model=out iset=I1 prefix14_class=2013
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmovg P1, S0
cmp P2, P0
mov S1, P2
cmovg S1, P0
cmovle P2, P0
cmovg P0, P2
cmp P3, P2
cmovge P0, P3
cmovge P3, P2
mov P0, P3
cmp P1, S1
