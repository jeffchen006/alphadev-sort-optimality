# n=5 model=out iset=I1 prefix14_class=2027
cmp P0, P2
mov S1, P3
cmovge S0, P2
cmovge P2, P0
cmovge P0, S0
cmp P1, S1
cmovg S1, P1
cmovle P3, P1
cmp S1, P2
mov S2, P0
mov P1, P2
cmovge P2, S1
cmovle P1, S1
mov P2, P1
