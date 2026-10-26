# n=5 model=out iset=I1 prefix14_class=2564
mov S0, P0
cmp P1, P0
cmovle P0, P1
mov S2, P3
cmovge S0, P1
cmp P2, S2
cmovg S2, P2
cmovg P2, P3
cmp S0, S2
cmovge P3, S0
cmovg S0, S2
cmovle P3, S2
cmp P2, P0
mov P3, S0
