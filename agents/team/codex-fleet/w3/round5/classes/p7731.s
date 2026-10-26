# n=5 model=out iset=I1 prefix14_class=7731
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovle S0, P0
cmp P1, P3
mov S2, P1
cmovle S2, P3
cmovg P1, P3
cmp P2, P1
cmovl S1, P2
cmovl P2, P1
cmovl P1, S1
cmp S0, S2
cmovle P0, S0
