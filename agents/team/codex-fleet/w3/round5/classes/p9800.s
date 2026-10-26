# n=5 model=out iset=I1 prefix14_class=9800
mov S1, P2
cmp P0, P1
mov S2, P1
cmovg S2, P0
cmovge P0, P1
cmp S1, P3
cmovg S1, P3
cmovl P2, P3
cmp S2, P2
cmovg P3, P2
cmovg P2, S2
cmovg S2, P3
mov P2, S1
cmp P0, P2
