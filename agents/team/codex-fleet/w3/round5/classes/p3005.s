# n=5 model=out iset=I1 prefix14_class=3005
cmp P3, P0
mov S2, P3
mov S0, P2
cmovle P3, P0
cmovle P0, S2
cmp S0, P1
mov S1, P3
cmovg S0, P1
cmovg P1, P2
cmp S1, P1
cmovg S1, P1
cmovg P1, P3
cmp P0, S0
cmovge P1, S0
