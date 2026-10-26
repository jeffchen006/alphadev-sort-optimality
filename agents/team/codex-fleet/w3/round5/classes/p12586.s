# n=5 model=out iset=I1 prefix14_class=12586
cmp P3, P1
mov S2, P3
cmovge P3, P1
cmovle S2, P1
cmp P2, P0
mov S0, P3
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
cmp P0, S0
cmovl P3, P0
cmovl P0, S0
mov P3, S2
cmp P3, P2
