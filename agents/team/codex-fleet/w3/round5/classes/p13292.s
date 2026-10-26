# n=5 model=out iset=I1 prefix14_class=13292
cmp P1, P3
cmovle S0, P3
mov S1, P0
cmovg S0, P1
cmovg P1, P3
cmp P0, P2
cmovge S1, P2
cmovle P0, P2
mov S2, S1
cmp S1, P1
cmovg S1, P1
cmovle S2, P1
cmp S0, P0
cmovge S1, S0
