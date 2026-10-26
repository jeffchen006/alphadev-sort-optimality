# n=5 model=out iset=I1 prefix14_class=9728
mov S2, P2
cmp P0, P2
cmovg S2, P0
cmovl P2, P0
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmovle P3, S1
mov P0, P3
cmp S2, P0
cmovge P3, S2
cmovle P0, S2
cmp P2, P1
mov S0, P0
