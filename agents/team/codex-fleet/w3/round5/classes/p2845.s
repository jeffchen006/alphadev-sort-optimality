# n=5 model=out iset=I1 prefix14_class=2845
mov S1, P0
mov S0, P1
cmp P3, P0
cmovl S1, P3
cmovl P3, P0
cmp P1, P2
mov P0, P3
cmovge P1, P2
cmovge P2, S0
cmp P2, P0
cmovle P3, P2
cmovle P2, P0
cmp P1, S1
cmovge P2, P1
