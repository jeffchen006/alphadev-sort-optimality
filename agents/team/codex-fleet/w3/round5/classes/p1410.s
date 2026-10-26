# n=5 model=out iset=I1 prefix14_class=1410
cmp P1, P3
mov S2, P1
mov S1, P2
cmovl S2, P3
cmovge P1, P3
cmp P0, P2
cmovl P2, P0
cmovg S1, P0
cmovge P0, P2
cmp S1, S2
cmovge P3, S2
cmovg S2, S1
cmovge S1, P3
cmp P0, P1
