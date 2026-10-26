# n=5 model=out iset=I1 prefix14_class=8111
cmp P3, P2
cmovge S2, P2
cmovle S2, P3
cmovl P3, P2
cmp P0, P1
cmovle S0, P1
mov S1, S2
cmovl P1, P0
cmovl P0, S0
cmp S1, P1
cmovl S1, P1
cmovg S2, P1
mov P1, P3
mov S2, S1
