# n=5 model=out iset=I1 prefix14_class=2774
cmp P2, P3
mov S2, P2
cmovle S2, P3
cmovge P2, P3
cmp P0, P1
cmovl S1, P1
cmovge S1, P0
cmovg P0, P1
cmp S2, S1
mov P1, S1
cmovg P1, S2
cmovge S2, S1
mov P1, P2
cmp P0, P1
