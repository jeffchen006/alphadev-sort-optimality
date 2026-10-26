# n=5 model=out iset=I1 prefix14_class=12011
cmp P3, P0
mov S2, P2
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P2, P1
cmovg S2, P1
cmovl P2, P1
cmp S2, P3
cmovl S1, S2
cmovle S2, P3
cmovl P3, S1
mov P1, P0
cmp P2, P0
