# n=5 model=out iset=I1 prefix14_class=7608
mov S1, P0
cmp P0, P2
cmovle P0, P2
cmovle P2, S1
cmp P3, P1
cmovge S0, P1
cmovl S0, P3
cmovg P1, P3
cmp P2, S0
mov P3, S0
cmovl P3, P2
cmovge S0, P2
cmp P1, P0
mov P3, S0
