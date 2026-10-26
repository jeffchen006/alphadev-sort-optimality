# n=5 model=out iset=I1 prefix14_class=5731
mov S1, P1
cmp S1, P0
mov S0, P2
cmovg P1, P0
cmovge P0, S1
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
mov S2, P3
cmp S2, P1
cmovge P3, P1
mov P3, P0
cmovl S2, P1
cmp P3, S0
