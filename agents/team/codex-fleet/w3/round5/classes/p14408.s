# n=5 model=out iset=I1 prefix14_class=14408
mov S0, P0
cmp P2, P0
cmovle S0, P2
cmovge P0, P2
mov S2, P3
cmp P1, S2
cmovg P3, P1
cmovg P1, S2
cmp S0, P1
cmovg S2, S0
cmovge S0, P1
cmovg P1, S2
cmp P3, P0
cmovge P2, P3
