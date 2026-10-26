# n=5 model=out iset=I1 prefix14_class=6423
cmp P1, P0
mov S1, P1
cmovg P1, P0
cmovge P0, S1
mov S0, P2
cmp P3, P2
cmovle P2, P3
cmovg S0, P3
mov S2, S0
cmp P0, S2
cmovl S2, P0
cmovge S0, P0
cmp P2, P1
cmovg S1, P1
