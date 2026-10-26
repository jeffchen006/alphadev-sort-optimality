# n=5 model=out iset=I1 prefix14_class=857
mov S1, P3
mov S2, P1
cmp P3, P0
cmovg P3, P0
cmovl S1, P0
cmp P1, P2
cmovg S2, P2
mov P0, S1
cmovge P2, P1
cmp P2, S1
cmovge P0, P2
cmovl S1, P2
cmovge P2, S1
mov P0, S2
