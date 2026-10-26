# n=5 model=out iset=I1 prefix14_class=3205
mov S2, P3
cmp P0, S2
cmovle P3, P0
mov S0, P2
cmovg S2, P0
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
mov P2, S0
cmp P3, S0
cmovge P2, P3
cmovg P3, S0
cmp S2, P1
cmovle P0, P1
