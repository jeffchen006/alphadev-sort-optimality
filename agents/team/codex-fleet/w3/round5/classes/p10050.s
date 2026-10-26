# n=5 model=out iset=I1 prefix14_class=10050
cmp P2, P3
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
mov S0, P1
cmp P0, P1
mov S1, P2
cmovl P1, P0
cmovl P0, S0
cmp P0, S1
cmovge P2, P0
cmovg P0, S1
cmp P1, P3
cmovg S0, P3
