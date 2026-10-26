# n=5 model=out iset=I1 prefix14_class=1414
cmp P2, P3
mov S1, P2
cmovge P2, P3
cmovge P3, S1
cmp P1, P0
mov S1, P0
cmovg P0, P1
cmovge P1, S1
cmp P0, P3
mov S2, P0
cmovle S2, P3
cmovge P0, P3
cmp P1, P2
mov S0, P0
