# n=5 model=out iset=I1 prefix14_class=9953
cmp P1, P0
cmovl S0, P0
cmovge S0, P1
cmovl P0, P1
cmp P2, P3
cmovge P1, P2
cmovg P2, P3
cmovg P3, P1
cmp S0, P3
mov S1, S0
cmovg S0, P3
cmovg P3, S1
mov S1, S0
mov P3, P2
