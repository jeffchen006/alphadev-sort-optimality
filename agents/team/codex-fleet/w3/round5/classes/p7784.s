# n=5 model=out iset=I1 prefix14_class=7784
mov S2, P3
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
cmp P2, P1
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
cmp P0, S0
cmovg P3, S0
cmovg S0, P0
cmovg P0, P3
mov P0, S2
cmp P0, P2
