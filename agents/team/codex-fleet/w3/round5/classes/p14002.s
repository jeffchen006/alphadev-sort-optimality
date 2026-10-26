# n=5 model=out iset=I1 prefix14_class=14002
cmp P1, P3
cmovle S0, P1
cmovge S0, P3
mov S1, P0
cmovl P1, P3
cmp P2, P0
mov S2, S0
cmovl S1, P2
cmovge P0, P2
cmp P1, P0
cmovle P2, P1
cmovl P1, P0
cmovle P0, P2
mov P3, P0
