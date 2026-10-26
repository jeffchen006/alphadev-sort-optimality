# n=5 model=out iset=I1 prefix14_class=544
mov S0, P1
cmp P3, S0
cmovg P1, P3
mov S2, P0
cmovl S0, P3
cmp S2, P2
cmovg S2, P2
cmovg P2, P0
mov P0, S0
cmp S2, S0
cmovge P0, S2
cmovg S2, S0
mov S2, P1
cmp P2, S2
