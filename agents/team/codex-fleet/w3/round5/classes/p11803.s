# n=5 model=out iset=I1 prefix14_class=11803
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
mov S0, P1
cmp P3, S0
cmovge P1, P3
cmovle S0, P3
mov P1, P0
cmp P0, P2
