# n=5 model=out iset=I1 prefix14_class=10310
cmp P1, P0
mov S1, P0
cmovge S1, P1
cmovge P1, P0
cmp P3, P2
mov P0, P3
cmovle P3, P2
cmovge P0, P2
cmp S1, P3
mov S0, P0
cmovge S2, P3
cmovg P3, S1
cmovge S1, S2
mov P3, S1
