# n=5 model=out iset=I1 prefix14_class=3332
mov S0, P0
mov S1, P3
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmp S0, P2
cmovge S0, P2
cmovge P2, P0
cmp S1, S0
cmovg S2, S1
cmovle S2, S0
cmovg S1, S0
cmovg S0, S2
mov P3, P2
