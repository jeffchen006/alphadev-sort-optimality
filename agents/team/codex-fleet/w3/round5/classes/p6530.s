# n=5 model=out iset=I1 prefix14_class=6530
mov S0, P2
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
cmovge S0, P3
mov S2, P1
cmovle P2, P3
cmovle P3, S0
cmp S0, P0
cmovle P3, P0
cmovge S0, P0
cmp P2, P1
