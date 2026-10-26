# n=5 model=out iset=I1 prefix14_class=14378
mov S0, P1
cmp P3, P1
cmovle P1, P3
mov S2, P0
cmovg S0, P3
cmp S2, P2
cmovge S2, P2
cmovg P2, P0
cmp P1, S2
cmovg P0, P1
cmovge P1, S2
cmovg S2, P0
cmp P2, S0
mov P1, P2
