# n=5 model=out iset=I1 prefix14_class=322
cmp P1, P2
mov S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P0, P3
mov S0, P3
cmovge P3, P0
cmovl S0, P0
mov P0, S0
cmp P1, P0
cmovl P0, P1
cmovle P1, S0
cmovge S0, P1
cmp P2, P3
