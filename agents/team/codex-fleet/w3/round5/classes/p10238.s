# n=5 model=out iset=I1 prefix14_class=10238
mov S0, P0
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmp P1, P3
cmovg S2, P3
cmovg P3, P1
cmovg P1, S2
mov P0, P3
cmp P3, P2
cmovle P3, P2
cmovg P0, P2
cmp S0, P1
mov P2, P0
