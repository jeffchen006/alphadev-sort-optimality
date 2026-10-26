# n=5 model=out iset=I1 prefix14_class=12470
mov S0, P3
cmp P1, P0
mov S2, P1
cmovle P1, P0
cmovge S2, P0
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
cmp S0, S2
cmovge P0, S2
cmovg S2, S0
cmovge S0, P0
cmp P1, P2
mov S0, S2
