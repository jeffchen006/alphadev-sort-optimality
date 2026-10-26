# n=5 model=out iset=I1 prefix14_class=11065
cmp P3, P1
mov S0, P1
cmovg S0, P3
cmovl P1, P3
cmp P2, P0
cmovle P3, P2
cmovl P2, P0
cmovle P0, P3
cmp S0, P2
cmovge S2, P2
cmovge P2, S0
cmovl S2, S0
cmp P0, P1
cmovge S0, P0
