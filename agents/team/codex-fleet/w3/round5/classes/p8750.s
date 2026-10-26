# n=5 model=out iset=I1 prefix14_class=8750
mov S0, P3
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovle P1, S2
mov S1, P3
cmp P0, S1
cmovl S1, P0
cmovl P0, P3
cmp P2, P1
cmovle S0, P2
