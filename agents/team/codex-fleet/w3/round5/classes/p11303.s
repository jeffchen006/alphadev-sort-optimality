# n=5 model=out iset=I1 prefix14_class=11303
mov S2, P2
mov S1, P0
cmp S2, P1
cmovl S2, P1
cmovle P1, P2
cmp S1, P3
cmovl S1, P3
mov P2, S2
cmovl P3, P0
cmp S2, S1
cmovg S2, S1
cmovge S1, P2
cmp P1, P3
cmovge S0, P1
