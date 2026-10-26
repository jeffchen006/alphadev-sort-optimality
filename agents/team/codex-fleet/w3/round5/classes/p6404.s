# n=5 model=out iset=I1 prefix14_class=6404
cmp P3, P1
cmovg S2, P3
cmovg P3, P1
cmovg P1, S2
mov S0, P2
cmp P0, P2
cmovg S0, P0
cmovl P2, P0
cmovl P0, S0
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
mov S0, P0
mov P1, P2
