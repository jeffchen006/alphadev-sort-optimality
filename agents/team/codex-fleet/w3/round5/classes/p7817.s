# n=5 model=out iset=I1 prefix14_class=7817
mov S2, P2
cmp P3, P2
cmovl P2, P3
cmovge S2, P3
cmp P1, P0
mov S0, P1
cmovg S0, P0
cmovg P0, P1
cmp S0, P2
cmovle P3, P2
mov P1, S2
cmovl P2, S0
cmovl S0, P3
cmp S2, P0
