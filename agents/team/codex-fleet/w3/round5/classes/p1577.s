# n=5 model=out iset=I1 prefix14_class=1577
mov S2, P0
mov S0, P2
cmp S2, P3
cmovg S2, P3
cmovge P3, P0
cmp P1, P2
cmovge S0, P1
cmovle P2, P1
mov S1, S0
cmovge P1, P2
cmp S2, P2
cmovg P2, S2
mov P0, P2
cmovle P1, S2
