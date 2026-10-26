# n=5 model=out iset=I1 prefix14_class=11482
mov S2, P2
mov S1, P3
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmp P3, P0
cmovg P3, P0
cmovge P0, S1
cmp P3, P1
mov S0, S2
cmovle S1, P3
cmovl P3, P1
mov P2, P3
cmovle P1, S1
