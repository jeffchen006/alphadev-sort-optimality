# n=5 model=out iset=I1 prefix14_class=12986
cmp P0, P3
mov S1, P3
cmovl S1, P0
cmovl P0, P3
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmovl P2, S2
mov P3, S1
cmp P3, P1
cmovl S1, P1
cmovge P3, P1
cmp P2, P0
cmovg S0, P0
