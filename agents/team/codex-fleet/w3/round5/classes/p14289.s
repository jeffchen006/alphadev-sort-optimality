# n=5 model=out iset=I1 prefix14_class=14289
cmp P3, P0
mov S1, P2
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
cmp S1, P1
cmovge P2, P1
cmovle S1, P1
mov S2, P2
cmp P3, P2
cmovg P2, P3
cmovl S2, P3
cmp P0, S1
cmovle P3, S1
