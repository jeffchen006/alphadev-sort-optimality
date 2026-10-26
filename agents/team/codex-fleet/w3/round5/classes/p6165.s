# n=5 model=out iset=I1 prefix14_class=6165
cmp P3, P2
cmovg S2, P3
cmovle S2, P2
cmovg P3, P2
cmp P0, P1
cmovl S1, P0
cmovge S1, P1
cmovge P1, P0
cmp S2, P1
cmovge P2, P1
cmovge P1, S2
mov P0, P3
cmovge S2, P2
cmp S1, P0
