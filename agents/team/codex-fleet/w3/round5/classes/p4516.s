# n=5 model=out iset=I1 prefix14_class=4516
mov S1, P3
cmp P1, P0
cmovg S0, P1
cmovle S0, P0
cmovg P1, P0
cmp S1, P2
cmovge P3, P2
cmovge P2, S1
mov S2, P2
cmp P2, S0
cmovge P2, S0
cmovge S0, S2
cmp P1, P3
cmovle P0, P1
