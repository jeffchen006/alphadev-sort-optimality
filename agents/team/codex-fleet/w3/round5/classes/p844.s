# n=5 model=out iset=I1 prefix14_class=844
cmp P0, P1
cmovl S2, P1
cmovge S2, P0
mov S1, P3
cmovge P0, P1
cmp S1, P2
cmovg S1, P2
cmovg P2, P3
cmp P2, S2
cmovge P1, S2
cmovg S2, P2
cmovge P2, P1
cmp P0, S1
cmovle S2, S1
