# n=5 model=out iset=I1 prefix14_class=542
cmp P0, P3
cmovle S0, P0
cmovge S0, P3
cmovg P3, P0
mov S2, P2
cmp S2, P1
cmovge S2, P1
mov S1, S2
cmovge P1, P2
cmp S0, S2
mov P0, P3
cmovg S1, S0
cmovg S0, S2
cmp P1, P0
