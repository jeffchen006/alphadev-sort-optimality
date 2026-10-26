# n=5 model=out iset=I1 prefix14_class=12703
cmp P3, P2
cmovg S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P0, P1
mov S2, P0
mov S0, P3
cmovl P0, P1
cmovl P1, S2
cmovl S2, P0
cmp P1, P3
cmovg P3, P1
cmovge P1, S0
mov P1, P3
