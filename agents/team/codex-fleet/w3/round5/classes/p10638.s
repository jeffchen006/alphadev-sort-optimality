# n=5 model=out iset=I1 prefix14_class=10638
cmp P2, P3
cmovl S1, P3
mov S0, P1
cmovle P3, P2
cmovl P2, S1
cmp P0, P1
cmovl P1, P0
cmovle P0, S0
cmovge S0, P0
cmp P0, P2
cmovg P0, P2
cmovl S0, P2
mov S0, P1
cmp P3, P1
