# n=5 model=out iset=I1 prefix14_class=11584
mov S0, P2
cmp P1, S0
mov S2, P0
cmovg S0, P1
cmovle P2, P1
cmp P0, P3
cmovle S2, P3
mov S1, P2
cmovge P0, P3
cmp P0, S1
cmovg S1, P0
cmovg P0, P2
cmp S0, S2
cmovge P0, S2
