# n=5 model=out iset=I1 prefix14_class=6630
mov S1, P1
cmp P1, P0
mov S2, P2
cmovl S1, P0
cmovl P0, P1
cmp S2, P3
cmovg P2, P3
cmovle S2, P3
cmp S1, S2
cmovge P3, S2
cmovg S2, S1
cmovge S1, P3
cmp P0, P2
mov P1, P0
