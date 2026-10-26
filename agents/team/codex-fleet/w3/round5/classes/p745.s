# n=5 model=out iset=I1 prefix14_class=745
cmp P2, P3
cmovl S2, P2
cmovge S2, P3
cmovle P2, P3
cmp P1, P0
mov P3, P1
cmovl P1, P0
cmovg P3, P0
mov S0, P1
cmp P1, P2
cmovle P1, P2
cmovle P2, S0
mov S0, S2
mov P1, P2
