# n=5 model=out iset=I1 prefix14_class=9264
cmp P1, P0
cmovge S2, P0
cmovg P0, P1
cmovg P1, S2
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovg S1, P2
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P0, S1
mov S0, P0
