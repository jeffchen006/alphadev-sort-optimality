# n=5 model=out iset=I1 prefix14_class=8391
mov S2, P1
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P2
cmovge P1, P2
cmovg P2, S2
cmp P2, P0
cmovle S0, P2
mov S2, P1
cmovl P2, P0
cmovle P0, S0
cmp S2, P3
