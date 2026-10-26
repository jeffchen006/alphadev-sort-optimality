# n=5 model=out iset=I1 prefix14_class=3926
mov S0, P0
cmp S0, P1
cmovg S0, P1
cmovle P0, P1
cmp P2, P3
cmovge S2, P2
cmovl S2, P3
cmovl P3, P2
cmp P3, S0
cmovg P1, S0
cmovg S0, P3
mov S1, P0
mov P2, S0
cmovg P3, P1
