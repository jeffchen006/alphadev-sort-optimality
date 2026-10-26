# n=5 model=out iset=I1 prefix14_class=6377
mov S1, P3
cmp P0, P3
cmovl P3, P0
cmovg S1, P0
mov S2, P1
cmp P2, S2
cmovg P1, P2
cmovl S2, P2
mov P0, S1
cmp P1, P0
cmovle S1, P1
cmovge P0, P1
cmp S2, P3
cmovge P0, S2
