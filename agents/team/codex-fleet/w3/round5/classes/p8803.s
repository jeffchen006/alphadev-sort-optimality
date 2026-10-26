# n=5 model=out iset=I1 prefix14_class=8803
mov S0, P1
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P3, S0
cmovge P1, P3
cmovl S0, P3
cmp P1, P2
mov P3, P1
cmovl P3, P2
cmovge P1, P2
cmp P0, S0
mov P2, P0
