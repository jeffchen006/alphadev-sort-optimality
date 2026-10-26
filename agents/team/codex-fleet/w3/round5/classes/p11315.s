# n=5 model=out iset=I1 prefix14_class=11315
mov S2, P2
cmp S2, P3
cmovge S2, P3
cmovle P2, P3
cmp P1, P0
cmovge P3, P1
cmovge P1, P0
mov S1, P1
cmovg P0, P3
cmp P0, P2
mov S0, P0
cmovge P0, P2
cmovg P2, S0
cmp S1, S2
