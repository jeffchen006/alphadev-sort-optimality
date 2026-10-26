# n=5 model=out iset=I1 prefix14_class=10508
mov S2, P0
cmp P3, S2
mov S1, P1
cmovl S2, P3
cmovge P0, P3
cmp S1, P2
cmovg S1, P2
cmovle P1, P2
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
cmp S1, S2
mov P0, S1
