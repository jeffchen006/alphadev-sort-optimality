# n=5 model=out iset=I1 prefix14_class=3921
cmp P2, P1
cmovg S1, P2
mov S0, P3
cmovg P2, P1
cmovg P1, S1
cmp P3, P0
cmovl S0, P0
cmovl P0, P3
cmovge P3, P0
cmp P2, P0
cmovge P3, P2
cmovge P2, P0
mov P2, S0
cmp P1, S0
