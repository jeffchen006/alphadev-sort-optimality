# n=5 model=out iset=I1 prefix14_class=3193
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovge P2, P0
cmp P1, P3
mov S1, S0
cmovg S2, P1
cmovg P1, P3
cmovg P3, S2
cmp S0, P1
cmovg S1, P1
cmovle S0, P1
cmovge P1, S0
cmp P2, P3
