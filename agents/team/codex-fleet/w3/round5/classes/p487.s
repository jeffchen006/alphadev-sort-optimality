# n=5 model=out iset=I1 prefix14_class=487
cmp P2, P3
cmovl S0, P3
cmovge S0, P2
cmovl P3, P2
mov S1, P0
cmp P0, P1
cmovg S1, P1
cmovg P1, P0
cmp P3, S1
cmovle S2, S1
cmovl S1, P3
cmovl P3, S2
mov P0, S0
cmp S0, P1
