# n=5 model=out iset=I1 prefix14_class=5410
cmp P0, P2
mov S2, P2
mov S0, P1
cmovge S2, P0
cmovge P0, P2
cmp S0, P3
cmovg P1, P3
cmovle S0, P3
cmovle P3, P1
cmp P1, P0
cmovge P3, P0
cmovge P0, P1
cmp S2, S0
cmovge P1, S2
