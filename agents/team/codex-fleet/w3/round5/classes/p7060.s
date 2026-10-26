# n=5 model=out iset=I1 prefix14_class=7060
mov S1, P2
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P0, P3
cmovl S2, P0
cmovle P0, P3
mov S0, P2
cmovl P3, S2
cmp P2, P1
