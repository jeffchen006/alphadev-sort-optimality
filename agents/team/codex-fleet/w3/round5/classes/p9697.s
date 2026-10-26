# n=5 model=out iset=I1 prefix14_class=9697
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
mov S2, P3
cmovg P1, S0
cmp S2, P2
mov S0, P1
cmovg P3, P2
cmovle S2, P2
cmp P1, P0
