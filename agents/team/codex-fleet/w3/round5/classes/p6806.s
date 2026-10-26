# n=5 model=out iset=I1 prefix14_class=6806
cmp P2, P3
cmovge S0, P2
cmovl S0, P3
cmovle P3, P2
cmp P1, P0
mov P2, P1
cmovge P1, P0
cmovl P2, P0
cmp P2, S0
mov S1, P2
cmovle S1, S0
cmovle S0, P2
cmp P1, P3
cmovl P2, P1
