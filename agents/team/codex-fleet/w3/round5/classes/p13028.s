# n=5 model=out iset=I1 prefix14_class=13028
cmp P0, P2
cmovg S0, P0
cmovle S0, P2
cmovg P0, P2
cmp P3, P1
cmovl S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P0, S1
cmovle S2, P0
cmovle P0, S1
cmovl S1, S2
cmp S0, P1
cmovle S2, S0
