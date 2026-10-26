# n=5 model=out iset=I1 prefix14_class=6122
cmp P1, P0
mov S1, P0
cmovle P0, P1
cmovle P1, S1
mov S1, P3
cmp P2, S1
cmovge S1, P2
cmovg P2, P3
cmp P1, S1
cmovg S2, P1
mov S0, P0
cmovg P1, S1
cmovg S1, S2
cmp P2, S0
