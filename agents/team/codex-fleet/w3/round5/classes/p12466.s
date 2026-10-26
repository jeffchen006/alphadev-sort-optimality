# n=5 model=out iset=I1 prefix14_class=12466
mov S2, P2
cmp P2, P0
mov S0, P3
cmovle P2, P0
cmovge S2, P0
cmp P3, P1
cmovg S0, P1
cmovge P1, P3
cmp S0, S2
cmovg S1, S2
cmovg S2, S0
cmovg S0, S1
cmp P2, P1
mov S0, P1
