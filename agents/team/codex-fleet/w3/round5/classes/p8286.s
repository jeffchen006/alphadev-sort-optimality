# n=5 model=out iset=I1 prefix14_class=8286
mov S2, P1
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
cmovge P2, S1
cmp P0, P1
cmovle P1, P0
cmovl P0, S2
mov S2, P3
mov S0, P2
cmp S0, P1
cmovl S0, P1
cmovge P2, P1
cmp P0, S2
