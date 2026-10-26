# n=5 model=out iset=I1 prefix14_class=3958
mov S0, P3
cmp S0, P0
cmovge P3, P0
cmovl S0, P0
cmovl P0, P3
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovl P1, P2
cmp P1, P3
cmovg P3, P1
cmovl P0, P1
cmp S0, S2
cmovge P1, S0
