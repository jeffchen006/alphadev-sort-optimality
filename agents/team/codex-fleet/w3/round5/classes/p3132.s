# n=5 model=out iset=I1 prefix14_class=3132
cmp P0, P3
mov S0, P2
mov S1, P0
cmovge S1, P3
cmovge P3, P0
cmp P1, S0
cmovg S0, P1
cmovle P2, P1
cmp P2, S1
mov P0, P2
cmovge P2, S1
cmovle P0, S1
cmp S0, P3
cmovg P1, P3
