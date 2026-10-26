# n=5 model=out iset=I1 prefix14_class=1902
cmp P2, P0
cmovl S1, P0
mov S0, P3
cmovle P0, P2
cmovl P2, S1
cmp P1, S0
cmovg P3, P1
cmovl S0, P1
cmp P2, P3
cmovle P1, P2
cmovge P1, P3
cmovl P2, P3
mov S2, P1
mov S1, P0
