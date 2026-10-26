# n=5 model=out iset=I1 prefix14_class=3983
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovg S1, P2
mov S0, P3
cmp P0, P3
cmovle S0, P0
cmovg P3, P0
mov S2, S1
cmp S0, S2
cmovg S1, S0
cmovge S0, S2
cmp P3, P1
mov S0, P3
