# n=5 model=out iset=I1 prefix14_class=2943
mov S2, P3
mov S1, P1
cmp S1, P0
cmovge P1, P0
cmovge P0, S1
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov P3, S2
cmp P0, S2
cmovl P3, P0
cmovl P0, S2
cmp P1, P2
cmovg P0, P2
