# n=5 model=out iset=I1 prefix14_class=1213
mov S0, P0
cmp S0, P3
mov S2, P2
cmovle P0, P3
cmovle P3, S0
cmp P2, P1
mov S0, P0
cmovle S2, P1
cmovge P2, P1
cmp S0, S2
cmovge S0, S2
cmovge S2, P0
cmp P3, P2
mov P0, P3
