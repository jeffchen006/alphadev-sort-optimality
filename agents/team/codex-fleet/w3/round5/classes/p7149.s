# n=5 model=out iset=I1 prefix14_class=7149
mov S0, P3
cmp S0, P0
cmovg S0, P0
cmovge P0, P3
cmp P2, P1
mov P3, P1
cmovle P1, P2
mov S2, P1
cmovge P3, P2
cmp S0, S2
cmovg P1, S0
cmovg S0, S2
cmp P3, P0
cmovge S1, P0
