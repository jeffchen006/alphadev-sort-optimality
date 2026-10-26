# n=5 model=out iset=I1 prefix14_class=14064
cmp P0, P2
cmovl S0, P0
mov S2, P3
cmovl P0, P2
cmovl P2, S0
mov S1, P0
cmp P1, S2
cmovle P3, P1
cmovl P1, S2
cmp P0, P1
cmovge P0, P1
cmovl S1, P1
mov P1, P2
cmp P3, P2
