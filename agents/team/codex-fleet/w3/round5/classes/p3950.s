# n=5 model=out iset=I1 prefix14_class=3950
mov S0, P0
cmp S0, P1
cmovge P0, P1
cmovl S0, P1
cmovle P1, P0
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmovle P3, S1
mov S2, S0
cmp P3, P0
cmovg P1, P3
cmovl P0, P3
cmp S2, P2
