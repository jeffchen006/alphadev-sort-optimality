# n=5 model=out iset=I1 prefix14_class=469
mov S0, P1
mov S1, P0
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmp P1, P3
cmovg P1, P3
mov P0, S1
cmovge P3, S0
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
mov P2, P1
