# n=5 model=out iset=I1 prefix14_class=8613
cmp P3, P2
mov S0, P2
cmovle P2, P3
cmovg S0, P3
cmp P1, P0
cmovge S2, P1
cmovge P1, P0
cmovg P0, S2
cmp S0, P0
mov S1, P2
cmovg P3, P0
cmovg P0, S0
cmovg S0, P3
cmp S1, P1
