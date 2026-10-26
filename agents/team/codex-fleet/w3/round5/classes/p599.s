# n=5 model=out iset=I1 prefix14_class=599
mov S1, P2
mov S2, P3
cmp P3, P1
cmovge S2, P1
cmovle P3, P1
cmovge P1, P3
cmp P2, P0
cmovg S1, P0
cmovg P0, P2
cmp P0, P1
cmovl P1, P0
cmovg P3, P0
cmp S1, S2
cmovg S0, S1
