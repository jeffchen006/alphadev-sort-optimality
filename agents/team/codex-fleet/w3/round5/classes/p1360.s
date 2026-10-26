# n=5 model=out iset=I1 prefix14_class=1360
cmp P3, P2
mov S1, P2
cmovg P2, P3
cmovle S1, P3
cmp P1, P0
cmovge S0, P0
cmovle S0, P1
mov S2, P2
cmovg P0, P1
cmp P0, S2
cmovg P2, P0
cmovg P0, S2
cmp S1, S0
cmovle S2, S0
