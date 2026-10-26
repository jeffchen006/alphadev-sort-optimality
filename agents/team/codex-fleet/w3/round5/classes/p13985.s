# n=5 model=out iset=I1 prefix14_class=13985
mov S0, P3
cmp P3, P0
cmovg P3, P0
cmovle S0, P0
cmp P2, P1
cmovg P0, P2
cmovge P2, P1
cmovg P1, P0
mov S1, P1
cmp P1, S0
cmovg S1, S0
mov S2, S1
cmovge S0, P1
cmp P2, P3
