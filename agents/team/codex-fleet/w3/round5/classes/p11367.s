# n=5 model=out iset=I1 prefix14_class=11367
cmp P0, P2
cmovl S0, P2
cmovle P2, P0
mov S2, P3
cmovl P0, S0
cmp P3, P1
cmovge S2, P1
cmovl P3, P1
mov S1, P0
cmp P3, P0
cmovg P0, P3
mov P1, S2
cmovge P3, S1
mov P0, P3
