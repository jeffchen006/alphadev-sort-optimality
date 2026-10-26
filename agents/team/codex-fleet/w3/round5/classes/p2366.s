# n=5 model=out iset=I1 prefix14_class=2366
mov S2, P2
cmp P2, P3
cmovge P2, P3
cmovle S2, P3
mov S0, P0
cmp P1, P0
cmovge S0, P1
cmovle P0, P1
cmovle P1, S0
cmp S2, S0
cmovg S0, S2
cmovle P1, S2
cmp P2, P0
cmovge S0, P2
