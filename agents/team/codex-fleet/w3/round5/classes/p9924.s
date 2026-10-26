# n=5 model=out iset=I1 prefix14_class=9924
mov S1, P1
mov S0, P0
cmp P2, S1
cmovg P1, P2
cmovge P2, S1
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmp S0, P1
cmovge P0, P1
cmovg P1, S0
mov S2, P3
cmovg S0, P0
cmp S2, P2
