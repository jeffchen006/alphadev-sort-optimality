# n=5 model=out iset=I1 prefix14_class=4419
mov S2, P1
cmp P2, P0
cmovle S1, P2
cmovg S1, P0
cmovle P2, P0
cmp S2, P3
cmovge S2, P3
cmovge P3, P1
cmp P3, P2
cmovle P0, P3
mov S0, S1
cmovl P3, P2
cmovle P2, P0
mov P3, P2
