# n=5 model=out iset=I1 prefix14_class=12311
cmp P1, P2
cmovg S0, P2
cmovle S0, P1
mov S1, P3
cmovle P1, P2
cmp P0, P3
cmovle P3, P0
cmovg S1, P0
cmp P3, S0
cmovge S2, P3
cmovg P3, S0
cmovge S0, S2
mov P3, S1
cmp S1, P1
