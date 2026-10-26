# n=5 model=out iset=I1 prefix14_class=4136
mov S0, P2
cmp P1, P2
cmovle S0, P1
cmovg P2, P1
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
mov S2, S1
cmovge P0, P3
cmp S0, S1
cmovg S2, S0
cmovg S0, S1
cmp P0, P2
cmovle P3, P2
