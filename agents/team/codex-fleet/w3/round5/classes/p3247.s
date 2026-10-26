# n=5 model=out iset=I1 prefix14_class=3247
mov S0, P0
cmp P2, S0
mov S1, P3
cmovg S0, P2
cmovge P2, P0
cmp P1, S1
mov P0, P2
cmovg S1, P1
cmovge P1, P3
cmp P2, P1
cmovg P2, P1
cmovle P0, P1
cmp S1, S0
cmovg P3, S0
