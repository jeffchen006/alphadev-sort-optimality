# n=5 model=out iset=I1 prefix14_class=11336
mov S1, P2
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
cmp P1, P2
cmovg S1, P1
cmovge P1, P2
cmp S1, P3
mov P2, S1
cmovle S1, P3
cmovl P3, P2
mov P2, P1
cmp P0, P1
