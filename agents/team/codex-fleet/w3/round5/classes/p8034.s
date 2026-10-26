# n=5 model=out iset=I1 prefix14_class=8034
cmp P2, P1
mov S1, P2
mov S0, P0
cmovge P2, P1
cmovl S1, P1
cmp P0, P3
cmovl S0, P3
cmovg P0, P3
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
cmovl P0, S2
mov P2, S0
cmp S1, P2
