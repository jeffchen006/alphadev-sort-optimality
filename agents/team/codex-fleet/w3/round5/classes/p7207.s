# n=5 model=out iset=I1 prefix14_class=7207
mov S0, P3
mov S1, P0
cmp S0, P2
cmovl P3, P2
cmovg S0, P2
cmp P1, S1
cmovg P0, P1
cmovle S1, P1
mov S2, S1
cmp S2, S0
cmovl S1, S0
cmovge S2, S0
cmp P0, P3
cmovl P2, P0
