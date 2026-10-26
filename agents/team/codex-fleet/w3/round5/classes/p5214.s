# n=5 model=out iset=I1 prefix14_class=5214
mov S1, P0
cmp P0, P3
cmovle P0, P3
cmovg S1, P3
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
mov S2, S1
cmovge S0, P2
cmp S1, S0
cmovg S1, S0
cmovge S0, S2
cmp P1, P0
cmovge S2, P0
