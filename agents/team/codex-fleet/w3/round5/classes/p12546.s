# n=5 model=out iset=I1 prefix14_class=12546
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
mov S1, P2
cmp P1, P0
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P1, P2
cmovg P2, P1
cmovge P1, S1
mov P1, P0
cmp P0, P3
