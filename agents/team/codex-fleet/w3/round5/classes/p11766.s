# n=5 model=out iset=I1 prefix14_class=11766
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmp P3, P1
mov S2, P0
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P3, P0
cmovg S2, P3
cmovge P3, P0
cmp S0, P1
cmovge P0, S0
