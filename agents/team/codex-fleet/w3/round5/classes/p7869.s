# n=5 model=out iset=I1 prefix14_class=7869
cmp P2, P0
mov S2, P1
cmovl S1, P0
cmovge S1, P2
cmovle P0, P2
cmp P1, P3
mov S0, P0
cmovl P1, P3
cmovg S2, P3
cmp S2, P0
cmovge S0, S2
cmovg S2, P0
mov S2, P1
cmovge P0, S0
