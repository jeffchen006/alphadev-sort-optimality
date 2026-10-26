# n=5 model=out iset=I1 prefix14_class=811
mov S1, P0
cmp S1, P2
cmovge S1, P2
cmovl P0, P2
cmovg P2, P0
cmp P3, P1
mov S2, P3
cmovg S2, P1
cmovge P1, P3
cmp P1, P0
cmovg P2, P1
cmovl P0, P1
cmp S1, S2
mov P3, P0
