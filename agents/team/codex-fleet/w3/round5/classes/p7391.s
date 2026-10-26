# n=5 model=out iset=I1 prefix14_class=7391
mov S1, P3
cmp P3, P2
cmovle P3, P2
mov S2, P3
cmovle P2, S1
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, P0
mov S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P1, P3
