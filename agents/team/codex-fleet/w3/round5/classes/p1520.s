# n=5 model=out iset=I1 prefix14_class=1520
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
mov S2, P0
cmovle S0, P3
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
cmp S2, S0
cmovg P0, S2
cmovge S2, S0
cmovg S0, P0
cmp P1, P2
cmovle P3, P1
