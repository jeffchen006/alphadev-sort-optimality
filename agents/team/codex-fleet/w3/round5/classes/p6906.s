# n=5 model=out iset=I1 prefix14_class=6906
mov S2, P2
cmp P2, P0
cmovge S2, P0
mov S0, P1
cmovg P0, P2
cmp S0, P3
cmovg S0, P3
mov P2, P0
cmovle P1, P3
cmp P1, P2
cmovg P2, P1
cmovle P0, P1
cmp S2, S0
cmovge P2, S2
