# n=5 model=out iset=I1 prefix14_class=4722
mov S1, P2
cmp P2, P3
cmovle P2, P3
cmovg S1, P3
cmp P1, P0
cmovge P3, P0
cmovg P0, P1
cmovge P1, P3
mov S0, P0
mov S2, P1
cmp S1, S2
cmovge S2, S1
cmovge S1, P1
cmp P2, S0
