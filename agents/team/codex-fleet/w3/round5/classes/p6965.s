# n=5 model=out iset=I1 prefix14_class=6965
mov S2, P3
mov S0, P1
cmp P0, P1
cmovge P1, P0
cmovg P0, S0
cmp P2, P3
mov S0, P1
cmovle P3, P2
cmovge S2, P2
cmp S0, S2
cmovge S0, S2
cmovge S2, P1
cmp P3, P0
cmovle P1, P3
