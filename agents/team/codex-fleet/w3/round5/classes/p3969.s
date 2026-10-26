# n=5 model=out iset=I1 prefix14_class=3969
mov S2, P1
cmp P0, S2
cmovl S2, P0
cmovge P1, P0
mov P0, P2
cmp P0, P3
cmovl P0, P3
cmovle P3, P2
cmp P3, S2
cmovge S0, S2
cmovg S2, P3
cmovg P3, S0
mov S1, P0
cmp P1, S1
