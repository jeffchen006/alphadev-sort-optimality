# n=5 model=out iset=I1 prefix14_class=248
mov S2, P3
mov S0, P1
cmp P2, P3
cmovge S2, P2
cmovle P3, P2
cmovge P2, P3
cmp P1, P0
cmovg S0, P0
cmovg P0, P1
cmp S0, P3
cmovle P3, S0
cmovle S0, P2
cmp P0, S2
mov S1, P0
