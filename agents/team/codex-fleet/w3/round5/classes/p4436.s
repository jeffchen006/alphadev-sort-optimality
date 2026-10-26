# n=5 model=out iset=I1 prefix14_class=4436
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
cmovg P2, S2
mov S0, P1
cmp S0, P3
cmovle P1, P3
cmovge S0, P3
mov S1, P2
mov P3, P0
cmp P0, P1
cmovle P3, P1
cmovg P0, P1
cmp P2, S0
