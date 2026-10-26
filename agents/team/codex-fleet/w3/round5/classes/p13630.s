# n=5 model=out iset=I1 prefix14_class=13630
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
cmovge S2, P2
cmp P0, P3
cmovge S1, P0
cmovle S1, P3
cmovg P0, P3
cmp P1, P0
cmovge P2, P0
cmovge P0, P1
cmovge P1, P2
cmp S2, S1
cmovge P1, S1
