# n=5 model=out iset=I1 prefix14_class=6971
cmp P0, P3
cmovg S0, P3
cmovge P3, P0
mov S2, P1
cmovg P0, S0
cmp P2, P1
cmovge S2, P2
mov S1, P3
cmovle P1, P2
cmp S1, S2
cmovge S1, S2
cmovge S2, P3
cmp P0, P1
mov P3, P0
