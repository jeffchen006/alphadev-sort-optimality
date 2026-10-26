# n=5 model=out iset=I1 prefix14_class=13076
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
mov S0, P0
cmovge P2, S2
cmp P0, P1
cmovge P0, P1
cmovle S0, P1
cmp P0, P3
cmovge P1, P0
mov S1, S0
cmovge P0, P3
cmovge P3, P1
cmp P2, S1
