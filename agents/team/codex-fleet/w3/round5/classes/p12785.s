# n=5 model=out iset=I1 prefix14_class=12785
cmp P1, P3
cmovl S2, P1
cmovl P1, P3
cmovl P3, S2
mov S0, P0
cmp P2, S0
cmovg S0, P2
cmovge P2, P0
mov P0, P2
cmp P0, P3
cmovg P2, P3
cmovge P3, P0
mov P2, P1
cmp P1, S0
