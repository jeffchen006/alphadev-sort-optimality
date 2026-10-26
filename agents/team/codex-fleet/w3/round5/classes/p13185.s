# n=5 model=out iset=I1 prefix14_class=13185
mov S0, P0
cmp P3, S0
mov S2, P1
cmovge P0, P3
cmovle S0, P3
cmp P2, S2
mov S1, S0
cmovge S2, P2
cmovle P1, P2
cmp S1, P1
cmovg S1, P1
cmovle S0, P1
cmp P0, S2
cmovle P1, P0
