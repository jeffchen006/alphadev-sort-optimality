# n=5 model=out iset=I1 prefix14_class=6542
mov S2, P0
cmp P1, P0
mov S0, P3
cmovl P0, P1
cmovge S2, P1
cmp S0, P2
cmovle P3, P2
cmovl P2, S0
cmovle S0, P3
cmp P3, S2
cmovle S0, S2
cmovge P3, S2
cmp P0, P2
cmovl S2, P2
