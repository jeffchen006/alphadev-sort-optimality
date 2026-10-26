# n=5 model=out iset=I1 prefix14_class=9369
mov S0, P0
cmp S0, P3
cmovle P0, P3
cmovl P3, S0
cmp P1, P2
cmovle S0, P2
mov S2, P3
cmovl P2, P1
cmovl P1, S0
cmp P2, S2
cmovge P3, P2
cmovge P2, S2
cmp P0, P1
mov P2, P1
