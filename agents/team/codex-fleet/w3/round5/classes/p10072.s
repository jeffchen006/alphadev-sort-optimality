# n=5 model=out iset=I1 prefix14_class=10072
cmp P3, P1
cmovle S2, P3
mov S0, P2
cmovg S2, P1
cmovg P1, P3
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
mov S1, P1
cmp S1, S0
cmovg S1, S0
cmovle P1, S0
cmp P0, S2
cmovle S0, P0
