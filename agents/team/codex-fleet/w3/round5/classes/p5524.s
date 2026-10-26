# n=5 model=out iset=I1 prefix14_class=5524
cmp P1, P0
mov S1, P1
cmovl P1, P0
mov S2, P2
cmovl P0, S1
cmp S2, P3
cmovg P2, P3
cmovle S2, P3
cmp P2, P0
mov S0, P2
cmovle S0, P0
cmovge P2, P0
cmp P1, S2
cmovl P2, S2
