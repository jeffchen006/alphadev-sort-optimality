# n=5 model=out iset=I1 prefix14_class=3182
cmp P2, P1
cmovg S2, P1
cmovle S2, P2
cmovg P1, P2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovg P0, P2
cmp S2, P3
cmovge S1, P3
cmovl S1, S2
cmovle S2, P3
cmp P1, P0
cmovge P2, P0
