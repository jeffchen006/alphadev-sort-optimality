# n=5 model=out iset=I1 prefix14_class=11560
mov S2, P2
mov S0, P1
cmp P0, P2
cmovle S2, P0
cmovge P2, P0
cmp P3, P1
cmovl S0, P3
cmovle P3, P1
cmp S0, S2
cmovle P0, S2
cmovle S2, S0
cmovl S0, P0
cmp P3, P2
cmovl P0, P3
