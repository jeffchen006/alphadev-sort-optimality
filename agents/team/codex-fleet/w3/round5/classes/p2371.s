# n=5 model=out iset=I1 prefix14_class=2371
mov S0, P1
cmp S0, P3
cmovg S0, P3
mov S1, P0
cmovge P3, P1
mov P1, P3
cmp P2, P0
cmovle P0, P2
cmovg S1, P2
cmp S1, P3
cmovle P3, S1
cmovge P1, S1
mov P1, P3
mov S2, P0
