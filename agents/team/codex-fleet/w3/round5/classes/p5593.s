# n=5 model=out iset=I1 prefix14_class=5593
cmp P3, P0
mov S0, P3
cmovl S0, P0
cmovl P0, P3
cmovg P3, P0
cmp P2, P1
cmovle S1, P2
mov S2, S0
cmovl P2, P1
cmovle P1, S1
cmp P0, P1
cmovge P0, P1
cmovge P1, P3
cmp S2, P2
