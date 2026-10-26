# n=5 model=out iset=I1 prefix14_class=6139
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovle P1, S1
cmp P0, P2
mov S2, P1
cmovg S1, P2
cmovge P2, P0
mov S0, P2
cmovg P0, S1
cmp P2, P3
cmovge P2, P3
cmovl S0, P3
cmp P0, P1
