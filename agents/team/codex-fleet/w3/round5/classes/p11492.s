# n=5 model=out iset=I1 prefix14_class=11492
mov S2, P3
cmp P3, P0
mov S0, P1
cmovl S2, P0
cmovle P0, P3
cmp P1, P2
cmovge P1, P2
cmovle S0, P2
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmovl P1, S1
cmp S2, S0
cmovge P1, S2
