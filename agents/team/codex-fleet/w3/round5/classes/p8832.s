# n=5 model=out iset=I1 prefix14_class=8832
mov S0, P3
cmp P3, P1
cmovge P3, P1
cmovl S0, P1
mov P1, P0
cmp P2, P1
cmovg P1, P2
cmovl P0, P2
cmp P1, S0
cmovge P2, P1
cmovg P1, S0
cmovg S0, P2
cmp P0, P3
cmovge S1, P0
