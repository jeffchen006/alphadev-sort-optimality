# n=5 model=out iset=I1 prefix14_class=7940
cmp P1, P0
cmovge S2, P1
cmovle S2, P0
cmovge P1, P0
mov P0, S2
mov S0, P3
cmp S0, P2
cmovge S0, P2
cmovge P2, P3
cmp P1, S0
cmovge P3, S0
cmovg S0, P1
cmovg P1, P3
cmp S2, P2
