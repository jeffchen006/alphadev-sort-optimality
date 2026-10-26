# n=5 model=out iset=I1 prefix14_class=14048
mov S2, P3
cmp P1, P3
cmovle S2, P1
cmovg P3, P1
cmp P2, P0
mov S0, P0
cmovle S0, P2
mov S1, S0
cmovg P0, P2
cmp P0, P3
cmovge P2, P0
cmovge P0, P3
cmovg P3, P2
cmp S0, S2
