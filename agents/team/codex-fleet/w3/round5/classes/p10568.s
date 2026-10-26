# n=5 model=out iset=I1 prefix14_class=10568
mov S1, P2
mov S2, P0
cmp S1, P3
cmovl S1, P3
cmovg P2, P3
cmp P1, P0
cmovg P0, P1
cmovge P1, S2
mov S2, S1
cmp P0, S1
cmovg S2, P0
cmovge P0, S1
cmp P1, P2
cmovg S0, P2
