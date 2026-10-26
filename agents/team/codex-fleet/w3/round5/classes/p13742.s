# n=5 model=out iset=I1 prefix14_class=13742
cmp P1, P2
cmovg S2, P2
cmovle S2, P1
cmovle P1, P2
cmp P0, P3
cmovge P2, P3
mov S0, P1
cmovg P3, P0
cmovge P0, P2
cmp S0, P3
cmovge P1, P3
mov S1, P0
cmovge P3, S0
cmp S1, S2
