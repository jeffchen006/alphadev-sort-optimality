# n=5 model=out iset=I1 prefix14_class=10244
mov S2, P3
cmp P0, P3
cmovge P3, P0
cmovle S2, P0
mov S0, P1
cmp S0, P2
cmovle P1, P2
cmovg S0, P2
mov S1, P1
cmp S1, P3
cmovle S1, P3
cmovg P1, P3
cmp S2, S0
cmovge P3, S0
