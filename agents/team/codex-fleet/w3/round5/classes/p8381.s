# n=5 model=out iset=I1 prefix14_class=8381
cmp P1, P0
cmovl S1, P1
cmovl P1, P0
mov S0, P2
cmovl P0, S1
cmp P2, P3
cmovge P2, P3
cmovg P3, S0
cmovg S0, P2
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P2, P0
