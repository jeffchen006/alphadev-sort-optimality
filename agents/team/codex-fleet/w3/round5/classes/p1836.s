# n=5 model=out iset=I1 prefix14_class=1836
mov S2, P0
cmp P3, P0
mov S1, P1
cmovg P0, P3
cmovge P3, S2
cmp P2, P1
cmovge P1, P2
mov S0, P1
cmovg P2, S1
cmp P1, P0
cmovge S0, P0
cmovle P1, P0
cmp P3, P2
mov P1, P2
