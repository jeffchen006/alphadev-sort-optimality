# n=5 model=out iset=I1 prefix14_class=5265
cmp P0, P2
mov S2, P1
cmovg S1, P2
cmovle S1, P0
cmovg P2, P0
cmovge P0, S1
cmp P3, S2
cmovg P1, P3
cmovle S2, P3
cmp S1, S2
cmovge P0, S2
cmovle S1, S2
cmp P2, P1
cmovl S0, P2
