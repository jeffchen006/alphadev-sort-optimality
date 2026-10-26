# n=5 model=out iset=I1 prefix14_class=1435
mov S0, P3
mov S1, P0
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmp P1, P3
cmovge P3, P1
cmovg P1, S0
cmovge S0, P3
cmp P3, P2
cmovle P3, P2
cmovge S0, P2
cmp S1, P1
cmovge P3, P1
