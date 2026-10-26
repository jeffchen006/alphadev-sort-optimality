# n=5 model=out iset=I1 prefix14_class=866
cmp P2, P0
mov S0, P2
cmovl P2, P0
cmovg S0, P0
mov S1, P2
mov P0, P3
cmp P0, P1
cmovg P3, P1
cmovge P1, P0
cmovg P0, P3
cmp P1, S1
cmovl P2, P1
cmovge S1, P1
mov S1, P2
