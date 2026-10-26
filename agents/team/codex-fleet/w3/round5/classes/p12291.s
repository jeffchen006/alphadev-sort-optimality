# n=5 model=out iset=I1 prefix14_class=12291
mov S0, P0
cmp P2, S0
cmovle S0, P2
mov S2, S0
cmovge P0, P2
cmp P1, P3
cmovge P2, P3
cmovg P3, P1
cmovge P1, P2
cmp S0, P1
cmovg S2, P1
cmovge P1, S0
cmp P3, P0
cmovle P2, P3
