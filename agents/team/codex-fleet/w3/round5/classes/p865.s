# n=5 model=out iset=I1 prefix14_class=865
cmp P2, P1
mov S0, P2
cmovg S0, P1
cmovl P2, P1
mov P1, P0
mov S2, P2
cmp P0, P3
cmovg P0, P3
cmovge P3, P1
cmovge P1, P0
cmp P3, S2
cmovl S2, P3
cmovg P2, P3
mov P2, S2
