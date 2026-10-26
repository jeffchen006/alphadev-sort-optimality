# n=5 model=out iset=I1 prefix14_class=5337
cmp P0, P1
mov S0, P3
mov S2, P0
cmovl S2, P1
cmovl P1, P0
cmp P2, S0
cmovg S0, P2
cmovg P2, P3
cmp P1, P2
mov S1, P2
cmovle P2, P1
cmovge S1, P1
mov P1, S0
cmp S2, S0
