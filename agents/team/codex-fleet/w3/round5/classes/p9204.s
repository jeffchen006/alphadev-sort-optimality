# n=5 model=out iset=I1 prefix14_class=9204
cmp P2, P1
mov S2, P2
mov S0, P0
cmovl S2, P1
cmovge P2, P1
mov S1, P2
cmp P3, P0
cmovle S0, P3
cmovg P0, P3
cmp S0, P2
cmovg P2, S0
cmovle S1, S0
cmp P0, S2
cmovge S1, S2
