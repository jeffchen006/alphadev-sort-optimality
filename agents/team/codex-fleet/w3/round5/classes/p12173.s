# n=5 model=out iset=I1 prefix14_class=12173
cmp P3, P1
cmovg S1, P3
mov S0, P0
cmovle S1, P1
cmovg P3, P1
cmp S0, P2
cmovge P0, P2
cmovle S0, P2
cmp P0, P3
cmovg P2, P0
mov S2, S1
cmovg P0, P3
cmovg P3, P2
cmp S1, S0
