# n=5 model=out iset=I1 prefix14_class=5004
mov S1, P0
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovg S2, P3
cmp P1, P0
cmovge P0, P1
cmovle S1, P1
cmp S1, P2
cmovle S0, P2
mov P3, P0
cmovl P2, S1
cmovl S1, S0
cmp P3, S2
