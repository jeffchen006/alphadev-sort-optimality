# n=5 model=out iset=I1 prefix14_class=1467
mov S0, P1
cmp P1, P2
mov S2, P0
cmovge P1, P2
cmovg P2, S0
cmp S2, P3
cmovl P0, P3
cmovl P3, S2
cmp P2, P0
cmovge S0, P0
cmovle S0, P2
cmovle P2, P0
cmp P3, P1
cmovg P0, P1
