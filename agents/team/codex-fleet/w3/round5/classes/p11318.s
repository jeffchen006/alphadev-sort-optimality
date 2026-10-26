# n=5 model=out iset=I1 prefix14_class=11318
mov S0, P3
cmp P3, P2
cmovge P3, P2
cmovg P2, S0
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
mov S2, P2
mov S1, P0
cmp P1, S2
cmovle P2, P1
cmovg S2, P1
cmp S1, P3
