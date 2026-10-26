# n=5 model=out iset=I1 prefix14_class=12795
mov S2, P1
cmp P3, P1
mov S1, P2
cmovle P1, P3
cmovge S2, P3
cmp S1, P0
cmovg P2, P0
mov S0, P1
cmovge P0, S1
cmp S0, P2
cmovge S0, P2
cmovge P2, P1
cmp S2, P0
cmovg S1, P0
