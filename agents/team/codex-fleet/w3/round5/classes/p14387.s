# n=5 model=out iset=I1 prefix14_class=14387
mov S1, P2
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovle P3, S2
cmp S1, P1
mov S0, P0
cmovle S1, P1
cmovg P2, P1
cmp S0, P2
cmovge P0, P2
mov P0, S1
cmovl S0, P2
cmp P3, S1
