# n=5 model=out iset=I1 prefix14_class=11346
mov S0, P0
cmp P1, S0
cmovge S0, P1
cmovg P1, P0
mov S2, P2
cmp S2, P3
cmovle S2, P3
mov S1, P1
cmovg P2, P3
cmp S2, S0
cmovl P0, S2
cmovle S2, S0
cmovl S0, P0
mov P3, S0
