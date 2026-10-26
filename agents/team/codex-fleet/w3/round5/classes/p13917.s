# n=5 model=out iset=I1 prefix14_class=13917
mov S2, P2
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
mov S2, P3
cmp S2, P1
cmovle P3, P1
cmovge S2, P1
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp S2, P0
cmovle P2, S2
