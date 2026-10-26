# n=5 model=out iset=I1 prefix14_class=12502
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
mov S2, P2
mov S0, P0
cmovl P3, S1
cmp P1, S2
cmovle S2, P1
cmovge P2, P1
cmp P3, S2
mov P1, P3
cmovle P3, S2
cmovle S2, P1
mov S2, P3
