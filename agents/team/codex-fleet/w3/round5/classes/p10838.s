# n=5 model=out iset=I1 prefix14_class=10838
cmp P2, P3
mov S1, P1
cmovge S0, P2
cmovg P2, P3
cmovg P3, S0
cmp S1, P0
cmovl S1, P0
mov S2, S1
cmovg P1, P0
cmp P3, S2
cmovg S1, P3
mov S1, P1
cmovg P3, S2
cmp S1, P2
