# n=5 model=out iset=I1 prefix14_class=9784
cmp P1, P3
cmovle S2, P3
mov S0, P0
cmovg S2, P1
cmovg P1, P3
cmp P2, P0
cmovle S0, P2
cmovge P0, P2
mov S1, S2
cmp S2, P0
cmovge S1, P0
cmovle S2, P0
cmp S0, P1
cmovle P3, S0
