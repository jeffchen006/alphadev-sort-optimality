# n=5 model=out iset=I1 prefix14_class=3121
mov S1, P1
cmp P0, P3
cmovle S2, P0
cmovg S2, P3
cmovg P3, P0
cmp P2, P1
mov S0, S2
cmovge S1, P2
cmovl P1, P2
cmp S2, P1
cmovge S0, P1
cmovl S2, P1
mov S0, P3
cmp S1, S0
