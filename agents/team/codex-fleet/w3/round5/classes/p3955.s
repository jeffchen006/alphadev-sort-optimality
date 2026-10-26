# n=5 model=out iset=I1 prefix14_class=3955
mov S0, P3
cmp S0, P1
cmovl S0, P1
cmovge P3, P1
cmovl P1, P3
cmp P2, P0
mov S2, P2
cmovle S2, P0
cmovl P0, P2
cmp P0, P1
cmovl P3, P0
cmovg P1, P0
cmp S0, S2
cmovg P0, S0
