# n=5 model=out iset=I1 prefix14_class=12174
cmp P0, P3
cmovl S1, P0
cmovle P0, P3
cmovge S1, P3
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmovle S0, P1
cmp P2, S1
cmovg P3, S1
cmovle P3, P2
cmovge S1, P2
cmp S0, P0
cmovge P3, S0
