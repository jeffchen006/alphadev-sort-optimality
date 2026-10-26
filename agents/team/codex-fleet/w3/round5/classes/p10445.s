# n=5 model=out iset=I1 prefix14_class=10445
cmp P2, P1
mov S1, P0
mov S2, P1
cmovg P1, P2
cmovle S2, P2
cmp S1, P3
cmovl S1, P3
cmovg P0, P3
cmp P1, S1
cmovle S0, P1
cmovl P1, S1
cmovl S1, S0
cmp P0, S2
cmovge P3, S2
