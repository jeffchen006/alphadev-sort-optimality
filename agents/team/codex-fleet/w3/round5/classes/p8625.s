# n=5 model=out iset=I1 prefix14_class=8625
mov S2, P1
cmp P3, S2
cmovg P1, P3
cmovle S2, P3
cmp P2, P0
mov S0, S2
cmovge P3, P2
cmovg P2, P0
cmovge P0, P3
cmp P0, P1
cmovg P3, P1
cmovg P1, P0
cmovg P0, P3
cmp S2, P2
