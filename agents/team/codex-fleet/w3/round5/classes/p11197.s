# n=5 model=out iset=I1 prefix14_class=11197
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
mov S2, P1
cmovge P0, S0
cmp P3, P2
cmovg S1, P3
cmovle S1, P2
cmovle P2, P3
cmp P1, S1
cmovge P1, S1
cmovle S2, S1
cmp P2, P0
cmovle S2, P0
