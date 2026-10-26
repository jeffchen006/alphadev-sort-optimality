# n=5 model=out iset=I1 prefix14_class=5005
mov S0, P1
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P0, S0
cmovl S0, P0
mov S2, P2
cmovge P1, P0
cmp S0, P3
cmovle S1, P3
cmovl P3, S0
cmovl S0, S1
cmp S2, P1
