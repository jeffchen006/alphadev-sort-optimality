# n=5 model=out iset=I1 prefix14_class=2171
cmp P0, P1
mov S0, P1
cmovl S0, P0
cmovl P0, P1
mov S1, P0
cmp P2, P3
cmovle P1, P3
cmovl P3, P2
cmovl P2, P1
cmp P2, S1
cmovge P0, P2
cmovl S1, P2
cmp P3, S0
mov P0, S0
