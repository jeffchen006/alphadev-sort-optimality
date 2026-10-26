# n=5 model=out iset=I1 prefix14_class=6225
cmp P0, P1
cmovl S0, P0
cmovge S0, P1
cmovl P0, P1
cmp P2, P3
cmovge P1, P2
cmovl P1, P3
cmovge P2, P3
mov P3, P0
cmp P1, P0
cmovg P3, P1
cmovl P0, P1
cmp P2, S0
cmovle P3, S0
