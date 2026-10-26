# n=5 model=out iset=I1 prefix14_class=14253
cmp P1, P3
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
mov S0, P2
cmp P0, S0
cmovge P2, P0
cmovge P0, S0
cmp P2, P3
cmovle S2, P3
cmovge S2, P2
cmovg P2, P3
cmp P1, P0
cmovge S0, P1
