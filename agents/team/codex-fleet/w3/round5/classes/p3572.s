# n=5 model=out iset=I1 prefix14_class=3572
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
mov S1, P3
cmp P0, S1
cmovg S1, P0
cmovl P3, P0
mov P0, P3
cmp P2, P3
cmovge P3, P2
cmovl P0, P2
cmp P1, S1
mov P2, P3
