# n=5 model=out iset=I1 prefix14_class=7423
cmp P3, P0
cmovl S1, P0
cmovge S1, P3
mov S2, P1
cmovge P3, P0
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmp P3, P2
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
cmp S2, S1
mov P0, P2
