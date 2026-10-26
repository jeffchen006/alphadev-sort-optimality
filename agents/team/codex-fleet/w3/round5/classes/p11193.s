# n=5 model=out iset=I1 prefix14_class=11193
cmp P0, P1
cmovge S2, P1
mov S1, P2
cmovg P1, P0
cmovge P0, S2
cmp P2, P3
cmovle S1, P3
mov S0, P1
cmovle P3, P2
cmp S0, S1
cmovle P1, S1
cmovg S0, S1
cmp P3, P0
cmovge S2, P3
