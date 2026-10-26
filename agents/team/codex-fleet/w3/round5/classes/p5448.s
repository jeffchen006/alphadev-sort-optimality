# n=5 model=out iset=I1 prefix14_class=5448
cmp P0, P2
cmovg S2, P2
cmovle S2, P0
cmovle P0, P2
cmp P1, P3
mov P2, S2
cmovge S1, P3
cmovge P3, P1
mov S0, P3
cmovge P1, S1
cmp P1, P2
cmovle P2, P1
cmovl P1, S2
mov S2, P1
