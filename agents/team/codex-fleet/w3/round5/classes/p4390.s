# n=5 model=out iset=I1 prefix14_class=4390
mov S0, P3
cmp P1, P3
cmovge P3, P1
mov S2, P2
cmovge P1, S0
cmp P0, P2
cmovle P2, P0
cmovg S2, P0
mov S1, P3
cmp S2, S1
cmovg S1, S2
cmovg S2, P3
mov P3, P1
cmp P1, P2
