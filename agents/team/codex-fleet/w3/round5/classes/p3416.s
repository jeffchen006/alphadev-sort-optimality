# n=5 model=out iset=I1 prefix14_class=3416
cmp P1, P0
mov S0, P1
cmovle P1, P0
cmovl P0, S0
mov S1, P3
cmovle S0, P1
cmp P3, P2
cmovge P3, P2
cmovl S1, P2
cmp P3, P0
cmovl P2, P0
cmovle P0, P3
cmovge P2, P3
mov P0, P2
