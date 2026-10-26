# n=5 model=out iset=I1 prefix14_class=12826
mov S2, P2
cmp P3, P2
cmovg P2, P3
cmovle S2, P3
mov S1, P0
cmp P0, P1
cmovg P0, P1
cmovge P1, S1
cmp S2, P0
mov S1, P2
cmovg S0, S2
cmovge S2, P0
cmovg P0, S0
cmp P1, S1
