# n=5 model=out iset=I1 prefix14_class=4586
cmp P1, P3
mov S1, P2
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
mov S0, P0
cmp P1, S0
cmovl S0, P1
cmovge P0, P1
mov P2, S0
mov P0, S1
