# n=5 model=out iset=I1 prefix14_class=11360
cmp P0, P3
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
mov S0, P2
cmovl S0, P1
cmovg P2, P1
cmp S0, P0
cmovge P1, P0
cmovg P0, S0
cmovg S0, P1
cmp P2, P3
mov S2, S0
