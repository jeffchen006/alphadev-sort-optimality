# n=5 model=out iset=I1 prefix14_class=6096
cmp P1, P3
cmovl S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P2, P0
cmovle S2, P0
cmovge S2, P2
cmovge P2, P0
cmp S2, P1
cmovge S1, S2
cmovg S2, P1
cmovg P1, S1
mov S0, P3
cmp S0, P2
