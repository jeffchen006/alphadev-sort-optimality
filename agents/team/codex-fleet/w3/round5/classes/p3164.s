# n=5 model=out iset=I1 prefix14_class=3164
cmp P0, P3
mov S2, P0
mov S1, P1
cmovg S2, P3
cmovg P3, P0
cmp P1, P2
cmovg P1, P2
mov P0, S2
cmovg P2, S1
cmp S2, P1
cmovge P0, P1
cmovl S2, P1
cmp P3, P2
mov P0, P2
