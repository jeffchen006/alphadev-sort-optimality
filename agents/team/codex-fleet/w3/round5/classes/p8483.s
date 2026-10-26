# n=5 model=out iset=I1 prefix14_class=8483
cmp P3, P0
mov S1, P3
cmovl P3, P0
cmovg S1, P0
cmp P1, P2
cmovle P0, P1
cmovl P1, P2
mov S0, S1
mov S2, P3
cmovl P2, P0
cmp S2, P1
cmovge P3, P1
cmovle S2, P1
cmovl P1, P3
