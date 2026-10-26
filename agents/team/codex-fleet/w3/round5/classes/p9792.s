# n=5 model=out iset=I1 prefix14_class=9792
mov S2, P1
cmp P0, P2
cmovg S0, P2
cmovg P2, P0
cmovg P0, S0
cmp P1, P3
cmovle P1, P3
mov S1, P2
cmovge S2, P3
cmp P1, P2
cmovg S1, P1
cmovg P1, P2
mov S1, P0
mov P2, P1
