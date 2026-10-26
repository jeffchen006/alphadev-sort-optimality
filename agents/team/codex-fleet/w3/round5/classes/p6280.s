# n=5 model=out iset=I1 prefix14_class=6280
mov S1, P3
cmp S1, P2
cmovge S1, P2
cmovge P2, P3
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
mov P3, P2
cmovg P1, S0
cmp P3, P0
cmovle P2, P0
cmovg P3, P0
cmp P1, S1
mov P0, P3
