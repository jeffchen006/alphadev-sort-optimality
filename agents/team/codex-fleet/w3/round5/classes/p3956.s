# n=5 model=out iset=I1 prefix14_class=3956
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovl S0, P2
mov P2, P3
cmp P1, P0
mov S2, P1
cmovle S2, P0
cmovl P0, P1
cmp P0, P2
cmovl P3, P0
cmovg P2, P0
cmp S0, S2
cmovge P0, S0
