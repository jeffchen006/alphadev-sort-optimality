# n=5 model=out iset=I1 prefix14_class=1416
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
cmovge P3, S0
cmp P0, P1
mov S1, P1
cmovg P1, P0
mov S2, P1
cmovg P0, S1
cmp S2, P3
mov S1, P2
cmovle P1, P3
cmovg S2, P3
cmp S1, P0
