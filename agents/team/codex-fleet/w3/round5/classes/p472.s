# n=5 model=out iset=I1 prefix14_class=472
cmp P2, P0
mov S0, P1
cmovle S1, P0
cmovge S1, P2
cmovle P0, P2
cmp S0, P3
cmovg S0, P3
cmovge P3, P1
cmp S0, P0
mov P1, P0
cmovle P0, S0
mov S2, P3
cmovle S0, P1
mov P0, S0
