# n=5 model=out iset=I1 prefix14_class=3246
mov S0, P0
cmp P2, S0
mov S1, P1
cmovg S0, P2
cmovge P2, P0
cmp P3, S1
cmovg S1, P3
cmovge P3, P1
mov P0, P2
cmp P2, P3
cmovg P2, P3
cmovle P0, P3
cmp S1, S0
cmovg P2, S0
