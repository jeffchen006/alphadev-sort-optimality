# n=5 model=out iset=I1 prefix14_class=11646
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmovle S2, P1
cmovge P1, S2
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
cmp S2, P3
cmovl S2, P3
cmovge P1, P3
cmp P2, P0
cmovl S0, P2
