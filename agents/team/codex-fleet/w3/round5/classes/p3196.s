# n=5 model=out iset=I1 prefix14_class=3196
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
cmovge P3, P0
cmp P2, P1
mov S2, P1
cmovle S2, P2
cmovge P1, P2
cmp S0, S2
cmovle P2, S2
cmovg P2, S0
cmovge S0, S2
cmp P1, P3
cmovle S0, P3
