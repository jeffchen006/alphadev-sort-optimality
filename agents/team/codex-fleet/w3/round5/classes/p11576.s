# n=5 model=out iset=I1 prefix14_class=11576
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovle S0, P0
cmp P3, P1
cmovle S2, P1
mov P0, P2
cmovle P1, P3
cmovle P3, S2
cmp P1, P0
cmovl P0, P1
cmovl P1, P2
cmp P3, S0
mov S1, P1
