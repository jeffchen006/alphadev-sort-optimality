# n=5 model=out iset=I1 prefix14_class=12915
mov S2, P0
cmp P0, P1
cmovg S2, P1
cmovg P1, P0
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
cmovge P3, P2
cmp S2, S0
mov P0, P1
cmovge S1, S0
cmovg S0, S2
cmovge S2, S1
cmp P3, P0
