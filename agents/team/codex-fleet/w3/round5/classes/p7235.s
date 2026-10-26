# n=5 model=out iset=I1 prefix14_class=7235
cmp P3, P1
mov S0, P3
cmovge P3, P1
cmovle S0, P1
cmp P0, P2
mov S2, P2
cmovg S2, P0
cmovg P0, P2
mov P2, S0
cmp P0, P3
cmovg S1, P0
cmovg P0, P3
cmovg P3, S1
cmp S2, P2
