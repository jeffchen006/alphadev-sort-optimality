# n=5 model=out iset=I1 prefix14_class=11635
cmp P0, P2
cmovle S2, P2
cmovge S2, P0
cmovge P0, P2
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
cmp S2, P3
cmovle P2, S2
cmovl S2, P3
cmovge P2, P3
cmp P1, P0
cmovg S1, P0
