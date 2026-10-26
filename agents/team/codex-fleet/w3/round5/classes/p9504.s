# n=5 model=out iset=I1 prefix14_class=9504
cmp P0, P1
cmovge S0, P0
cmovl S0, P1
cmovge P0, P1
cmp P2, P3
cmovg S1, P3
cmovle S1, P2
cmovle P2, P3
cmp S1, P0
cmovge P1, S1
cmovge S1, P0
mov S2, P2
cmovg P0, P1
cmp S2, S0
