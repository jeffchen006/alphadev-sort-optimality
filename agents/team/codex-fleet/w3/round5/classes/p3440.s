# n=5 model=out iset=I1 prefix14_class=3440
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
mov S2, P2
cmovg P3, S0
cmp P2, P1
cmovle P2, P1
cmovge S2, P1
mov P1, P3
cmp S2, P1
cmovg P1, S2
cmovg S2, P3
mov P3, P0
cmp P2, P0
