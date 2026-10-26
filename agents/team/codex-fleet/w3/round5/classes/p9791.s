# n=5 model=out iset=I1 prefix14_class=9791
mov S2, P1
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmovge P3, S0
cmp S2, P0
cmovle S2, P0
cmovg P1, P0
mov S1, P2
cmp S2, S1
cmovle P2, S2
cmovg S1, S2
mov S1, P3
cmovg S2, P2
