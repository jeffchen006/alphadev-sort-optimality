# n=5 model=out iset=I1 prefix14_class=784
mov S2, P3
cmp S2, P2
mov S0, P0
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P0, P1
cmovl S0, P1
cmovg P0, P1
mov P1, P2
cmp S0, P3
cmovge S2, S0
cmovle P3, S0
cmp P2, P0
