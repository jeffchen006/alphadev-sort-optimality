# n=5 model=out iset=I1 prefix14_class=7106
mov S2, P2
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
cmp P1, P0
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp S2, P3
cmovge P0, P3
