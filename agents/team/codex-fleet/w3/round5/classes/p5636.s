# n=5 model=out iset=I1 prefix14_class=5636
mov S1, P2
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmp P0, P3
cmovg S2, P3
mov S0, P1
cmovg P3, P0
cmovle S2, P0
cmp S2, S0
cmovg P1, S2
cmovle S0, S2
mov S2, S1
mov S0, P1
