# n=5 model=out iset=I1 prefix14_class=4732
cmp P3, P1
mov S0, P3
mov S1, P0
cmovle P3, P1
cmovg S0, P1
cmp P2, S1
cmovg S1, P2
cmovg P2, P0
mov P1, S0
cmp P2, P1
cmovg S0, P2
cmovge P2, P1
cmp S1, P3
cmovg P1, S0
