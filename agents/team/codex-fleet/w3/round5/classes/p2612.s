# n=5 model=out iset=I1 prefix14_class=2612
cmp P3, P2
mov S2, P2
cmovge P2, P3
mov S0, P0
cmovg P3, S2
mov S1, P2
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
cmp S0, P2
cmovle S1, S0
cmovle S0, P2
cmp P3, P1
cmovge P0, P1
