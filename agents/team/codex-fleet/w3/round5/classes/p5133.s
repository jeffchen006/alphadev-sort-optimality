# n=5 model=out iset=I1 prefix14_class=5133
cmp P3, P0
cmovle S1, P0
mov S2, P1
cmovle P0, P3
cmovg S1, P3
cmp P2, S2
cmovle P1, P2
cmovl P2, S2
mov P3, P1
cmp P0, P3
cmovge P1, P0
cmovl P3, P0
cmp P2, S1
cmovle S0, P2
