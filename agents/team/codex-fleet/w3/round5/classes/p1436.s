# n=5 model=out iset=I1 prefix14_class=1436
mov S0, P3
mov S1, P0
cmp S1, P1
cmovge S1, P1
cmovge P1, P0
cmp P2, P3
cmovg P3, P2
cmovg P2, S0
cmovg S0, P3
cmp P3, P1
cmovle P3, P1
cmovge S0, P1
cmp S1, P2
cmovge P3, P2
