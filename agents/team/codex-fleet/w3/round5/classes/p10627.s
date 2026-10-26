# n=5 model=out iset=I1 prefix14_class=10627
cmp P3, P0
cmovle S2, P0
mov S1, P2
cmovle P0, P3
cmovl P3, S2
cmp P2, P1
cmovle S1, P1
mov S0, S1
cmovge P2, P1
cmp P3, S1
cmovle S1, P3
cmovl P3, S0
mov P1, S1
mov P3, P2
