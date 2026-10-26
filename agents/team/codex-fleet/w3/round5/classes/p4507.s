# n=5 model=out iset=I1 prefix14_class=4507
cmp P0, P3
mov S0, P3
cmovg S0, P0
cmovge P0, P3
cmp P1, P2
mov P3, P1
cmovg P1, P2
cmovl P3, P2
cmp P3, S0
cmovge P2, S0
cmovge S0, P3
cmovl P2, P3
cmp P1, P0
mov S0, P0
