# n=5 model=out iset=I1 prefix14_class=4451
cmp P2, P3
mov S2, P3
cmovge P3, P2
cmovg P2, S2
cmp P0, P1
cmovl S2, P1
cmovge S2, P0
mov S0, S2
cmovl P1, P0
cmp S0, P3
cmovle S2, P3
cmovl P3, S0
cmp P1, P2
cmovle S1, P1
