# n=5 model=out iset=I1 prefix14_class=13755
cmp P2, P1
cmovg S0, P2
cmovge P2, P1
mov S2, P3
cmovle S0, P1
cmp P3, P0
cmovle S2, P0
mov S1, P2
cmovg P3, P0
cmp S0, S2
cmovge P1, S0
cmovg S0, S2
cmovg S2, P1
cmp P2, P3
