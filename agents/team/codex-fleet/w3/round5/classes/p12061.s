# n=5 model=out iset=I1 prefix14_class=12061
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
mov S2, P2
cmovge P0, S0
cmp P3, S2
cmovge S2, P3
cmovge P3, P2
cmp P1, P3
mov P2, P3
cmovle P2, P1
cmovg P3, P1
mov P2, P0
cmp P0, S2
