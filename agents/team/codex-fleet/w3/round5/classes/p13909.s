# n=5 model=out iset=I1 prefix14_class=13909
cmp P2, P0
cmovge S0, P0
cmovl S0, P2
cmovl P2, P0
cmp P1, P3
cmovg S1, P3
cmovge P3, P1
cmovg P1, S1
cmp P3, P2
cmovge S1, P2
mov P0, S0
cmovge P2, P3
cmovg P3, S1
cmp P0, P1
