# n=5 model=out iset=I1 prefix14_class=11579
cmp P1, P0
cmovge S0, P0
cmovl S0, P1
cmovle P1, P0
cmp P2, P3
cmovle P0, P2
cmovg P0, P3
cmovl P2, P3
mov P3, S0
cmp P0, S0
cmovle P3, P0
cmovle P0, S0
cmp P2, P1
cmovge S0, P1
