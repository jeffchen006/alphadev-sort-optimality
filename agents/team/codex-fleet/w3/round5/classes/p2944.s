# n=5 model=out iset=I1 prefix14_class=2944
mov S2, P3
mov S1, P2
cmp S1, P0
cmovge P2, P0
cmovge P0, S1
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
mov P3, S2
cmp P0, S2
cmovl P3, P0
cmovl P0, S2
cmp P2, P1
cmovg P0, P1
