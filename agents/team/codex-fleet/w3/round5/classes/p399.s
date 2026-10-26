# n=5 model=out iset=I1 prefix14_class=399
cmp P2, P3
mov S0, P3
cmovg S0, P2
mov S2, P0
cmovle P3, P2
cmp S2, P1
cmovge P0, P1
cmovg P1, S2
mov P2, P0
cmp P2, P3
cmovge P0, P3
cmovle P2, P3
mov S2, S0
mov P0, P2
