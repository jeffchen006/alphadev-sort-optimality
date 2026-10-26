# n=5 model=out iset=I1 prefix14_class=11809
mov S2, P3
cmp P1, S2
cmovl P3, P1
cmovle P1, S2
cmp P2, P0
cmovl S2, P2
mov S0, P1
cmovle P2, P0
cmovl P0, S2
cmp P2, P1
cmovl S0, P2
cmovg P1, P2
cmp P0, P3
mov P2, P3
