# n=5 model=out iset=I1 prefix14_class=5110
cmp P1, P3
mov S0, P2
mov S2, P1
cmovl P1, P3
cmovg S2, P3
cmp P2, P0
cmovge S0, P0
cmovle P2, P0
mov P3, S0
cmp S2, P3
cmovge P3, S2
cmovl S0, S2
mov S0, P3
cmp P2, P1
