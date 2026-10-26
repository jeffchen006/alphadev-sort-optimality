# n=5 model=out iset=I1 prefix14_class=1413
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovge P3, S1
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P0, P3
mov S2, P0
cmovl S2, P3
cmovge P0, P3
mov P3, P1
cmp P1, P2
