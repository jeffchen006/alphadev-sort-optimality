# n=5 model=out iset=I1 prefix14_class=5726
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
mov S2, P3
cmovle S0, P1
cmp P0, S2
mov S1, P2
cmovge S2, P0
cmovge P0, P3
cmp S0, P0
cmovge P1, S0
cmovg S0, P0
cmovge P0, P1
cmp S2, S1
