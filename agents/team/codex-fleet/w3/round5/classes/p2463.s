# n=5 model=out iset=I1 prefix14_class=2463
mov S1, P0
cmp S1, P2
cmovl S1, P2
cmovg P0, P2
cmp P1, P3
mov S2, P3
cmovge P3, P1
cmovge P1, S2
mov S2, P3
cmp P3, S1
cmovl S2, S1
cmovle S1, P3
cmp P1, P0
cmovg P2, P1
