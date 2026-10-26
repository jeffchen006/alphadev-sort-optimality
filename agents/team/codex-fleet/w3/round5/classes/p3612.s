# n=5 model=out iset=I1 prefix14_class=3612
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovle P3, P2
mov P2, P0
cmp P1, P2
cmovl P0, P1
cmovle P1, P2
cmovl P2, P0
cmp P3, P0
cmovle P2, P3
cmovl P3, P0
cmp P1, S0
cmovge P2, S0
