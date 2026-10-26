# n=5 model=out iset=I1 prefix14_class=9788
cmp P3, P0
cmovg S0, P0
cmovle S0, P3
cmovge P0, P3
mov S2, P0
cmp P1, P2
cmovge S1, P1
cmovle S1, P2
cmovg P1, P2
cmp S2, S1
cmovle S2, S1
cmovle S1, P0
cmp P1, S0
cmovl S2, P1
