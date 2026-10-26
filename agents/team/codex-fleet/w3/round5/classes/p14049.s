# n=5 model=out iset=I1 prefix14_class=14049
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
mov S2, P2
cmovle S0, P1
cmp P0, S2
cmovle P2, P0
cmovg S2, P0
cmp S2, P3
cmovge P0, S2
cmovg S2, P3
mov S1, S0
cmovge P3, P0
cmp S1, P2
