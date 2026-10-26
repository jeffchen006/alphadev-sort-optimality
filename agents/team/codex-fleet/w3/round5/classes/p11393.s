# n=5 model=out iset=I1 prefix14_class=11393
mov S0, P3
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
cmp S0, P2
cmovle S0, P2
cmovge P3, P2
mov S2, S0
cmp P0, S0
cmovl S0, P0
cmovl P0, S2
mov P0, S0
cmp P1, P3
