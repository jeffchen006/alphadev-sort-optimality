# n=5 model=out iset=I1 prefix14_class=4487
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
cmovl S2, P2
cmp P0, P3
cmovle S0, P0
cmovge S0, P3
cmovle P0, P3
cmp P0, S2
cmovg P3, P0
cmovg P0, S2
cmovg S2, P3
cmp S0, P1
cmovg S2, S0
