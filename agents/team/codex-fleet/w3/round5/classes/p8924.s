# n=5 model=out iset=I1 prefix14_class=8924
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
cmovl P2, S0
mov S1, P0
cmp P3, S1
cmovle S1, P3
cmovl P3, P0
cmp P2, P3
cmovle P0, P2
cmovge P0, P3
cmovl P2, P3
cmp P1, S1
mov P2, P0
