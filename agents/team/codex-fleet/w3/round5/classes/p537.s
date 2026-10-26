# n=5 model=out iset=I1 prefix14_class=537
mov S1, P2
mov S0, P3
cmp S1, P1
cmovg P2, P1
cmovg P1, S1
mov S2, P2
cmp S0, P0
cmovg P3, P0
cmovg P0, S0
cmp P3, S2
cmovl S2, P3
cmovge P2, P3
mov S2, P0
cmp P1, P0
