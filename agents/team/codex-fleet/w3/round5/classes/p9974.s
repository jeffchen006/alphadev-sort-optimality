# n=5 model=out iset=I1 prefix14_class=9974
cmp P3, P2
cmovle S0, P3
cmovge S0, P2
cmovg P2, P3
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
cmovg P0, P3
cmp P2, P0
cmovg P3, P2
cmovge P2, P0
cmovg P0, P3
mov S2, P1
cmp S2, S0
