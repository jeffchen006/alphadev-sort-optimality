# n=5 model=out iset=I1 prefix14_class=3188
mov S2, P0
cmp P2, P0
cmovge P0, P2
cmovle S2, P2
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
mov P2, P1
cmp S2, P1
cmovl P2, S2
cmovl S2, P1
mov S0, P3
cmp P0, P3
