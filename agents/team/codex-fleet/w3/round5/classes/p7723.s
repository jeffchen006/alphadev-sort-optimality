# n=5 model=out iset=I1 prefix14_class=7723
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovl S2, P1
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovge P0, P3
cmp P2, P0
cmovl S1, P0
cmovle P0, P2
cmovl P2, S1
mov P0, P2
cmp S0, S2
