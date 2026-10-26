# n=5 model=out iset=I1 prefix14_class=9509
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
mov S1, P1
cmp P1, P3
cmovg P1, P3
mov S0, P1
cmovge P3, S1
cmp P1, P2
cmovg S0, P2
cmovge P2, P1
cmp P0, P3
cmovle P1, P0
