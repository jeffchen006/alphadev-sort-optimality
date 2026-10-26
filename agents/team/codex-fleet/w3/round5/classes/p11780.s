# n=5 model=out iset=I1 prefix14_class=11780
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovg P3, S1
mov S0, P1
cmp P2, S0
cmovl P1, P2
cmovg S0, P2
cmp P0, S0
cmovg P2, S0
cmovg S0, P0
mov S0, P1
cmovg P0, P2
cmp P3, S0
