# n=5 model=out iset=I1 prefix14_class=5718
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovge P2, P1
mov P1, P3
cmp P0, P1
cmovg P3, P0
cmovge P0, P1
mov P1, P0
cmp P0, S0
cmovge P1, S0
cmovg S0, P0
cmp P3, P2
cmovl P0, P3
