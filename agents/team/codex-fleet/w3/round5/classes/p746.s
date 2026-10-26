# n=5 model=out iset=I1 prefix14_class=746
cmp P2, P3
cmovge S2, P3
cmovl S2, P2
cmovle P2, P3
cmp P0, P1
mov P3, P0
cmovl P0, P1
cmovg P3, P1
mov S0, P0
cmp P0, P2
cmovl P0, P2
cmovle P2, S0
mov P0, P2
mov S0, S2
