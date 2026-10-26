# n=5 model=out iset=I1 prefix14_class=12499
cmp P1, P0
mov S2, P1
cmovle P1, P0
cmovl P0, S2
cmp P3, P2
cmovge S2, P2
cmovl S2, P3
cmovge P2, P3
mov P3, P0
cmp P3, S2
cmovl P3, S2
cmovl S2, P0
cmp P2, P1
cmovle S0, P1
