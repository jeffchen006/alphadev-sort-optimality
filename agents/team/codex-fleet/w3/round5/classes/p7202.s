# n=5 model=out iset=I1 prefix14_class=7202
mov S0, P1
cmp S0, P2
cmovge S0, P2
cmovl P1, P2
cmp P3, P0
cmovg P2, P3
cmovg P3, P0
cmovg P0, P2
cmp P3, S0
cmovl S2, P3
cmovge S2, S0
cmovle P3, S0
cmovg S0, P3
cmp P1, P0
