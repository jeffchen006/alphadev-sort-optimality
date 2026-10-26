# n=5 model=out iset=I1 prefix14_class=2854
cmp P1, P3
mov S0, P1
cmovg P1, P3
cmovge P3, S0
mov S0, P2
cmp P2, P0
cmovg P2, P0
mov S2, P3
cmovl S0, P0
cmp S0, P3
cmovg P3, S0
cmovg S0, S2
cmp P2, P1
mov P3, P2
