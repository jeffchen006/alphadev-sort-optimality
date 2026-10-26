# n=5 model=out iset=I1 prefix14_class=9787
mov S0, P3
cmp S0, P0
cmovge S0, P0
cmovg P0, P3
cmp P1, P2
mov S1, P1
cmovle S1, P2
cmovge P1, P2
cmp S1, P0
mov P3, P1
cmovl S2, S1
cmovl S1, P0
cmovl P0, S2
cmp P3, S0
