# n=5 model=out iset=I1 prefix14_class=13897
mov S0, P3
cmp S0, P0
mov S1, P1
cmovg P3, P0
cmovg P0, S0
cmp P2, S1
cmovg P1, P2
cmovg P2, S1
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
mov S2, P0
cmp P3, P2
