# n=5 model=out iset=I1 prefix14_class=5580
mov S2, P0
cmp P1, S2
cmovge S2, P1
cmovge P1, P0
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovle S0, P2
cmp P1, P3
cmovge S1, P3
cmovle S1, P1
cmovge P3, P1
cmp S2, S0
cmovle P1, S0
