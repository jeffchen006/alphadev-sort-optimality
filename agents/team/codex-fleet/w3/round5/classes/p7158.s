# n=5 model=out iset=I1 prefix14_class=7158
mov S0, P3
cmp P3, P1
cmovge P3, P1
cmovle S0, P1
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
mov P1, P3
cmovl P2, S2
cmp P3, P0
cmovle P3, P0
cmovg P1, P0
cmp S0, P2
cmovge P1, P2
