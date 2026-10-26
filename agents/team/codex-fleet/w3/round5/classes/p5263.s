# n=5 model=out iset=I1 prefix14_class=5263
mov S0, P0
cmp P1, S0
cmovg P0, P1
mov S2, P2
cmovl S0, P1
mov P1, S0
cmp P3, S2
cmovge S2, P3
cmovl P2, P3
cmp S0, P2
cmovle P1, P2
cmovg S0, P2
mov S0, S2
cmp S0, P0
