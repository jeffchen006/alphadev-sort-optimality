# n=5 model=out iset=I1 prefix14_class=6164
cmp P3, P2
cmovg S2, P3
cmovle S2, P2
cmovg P3, P2
cmp P0, P1
cmovl S1, P0
cmovge S1, P1
cmovge P1, P0
cmp S2, P1
cmovge P0, P1
cmovge P1, S2
mov P2, S1
cmovge S2, P0
cmp P3, P2
