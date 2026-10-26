# n=5 model=out iset=I1 prefix14_class=7112
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmovl P3, S2
mov S0, P1
cmp S0, P0
cmovl S0, P0
cmovl P0, P1
cmp P0, P2
cmovge P1, P0
cmovg P0, P2
cmovle P1, P2
mov S1, P1
mov P2, P3
