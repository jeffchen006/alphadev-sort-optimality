# n=5 model=out iset=I1 prefix14_class=1065
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovle P1, S2
mov S0, P2
cmp S0, P3
cmovg S0, P3
cmovge P3, P2
cmp P3, P0
cmovge P2, P3
cmovg P3, P0
cmovg P0, P2
mov S1, P1
cmp S0, S1
