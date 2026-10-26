# n=5 model=out iset=I1 prefix14_class=2266
mov S0, P3
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovge S2, P1
cmp P2, S0
cmovg S0, P2
cmovg P2, P3
mov S1, S0
cmp S1, P0
cmovle S0, P0
cmovle P0, S1
cmp S2, P2
cmovg P3, S2
