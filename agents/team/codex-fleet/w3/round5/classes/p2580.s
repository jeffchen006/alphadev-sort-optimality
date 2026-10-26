# n=5 model=out iset=I1 prefix14_class=2580
mov S2, P1
cmp P3, P1
cmovge P1, P3
cmovg P3, S2
cmp P2, P0
mov S1, P0
cmovge S1, P2
cmovg P2, P0
cmp S1, P1
cmovl S0, S1
cmovl S1, P1
cmovge S0, P1
cmp P2, P3
mov S1, P3
