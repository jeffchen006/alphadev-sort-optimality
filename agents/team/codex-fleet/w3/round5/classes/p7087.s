# n=5 model=out iset=I1 prefix14_class=7087
cmp P0, P3
cmovge S0, P3
cmovge P3, P0
cmovg P0, S0
mov S1, P2
cmp P2, P1
cmovg S1, P1
cmovg P1, P2
mov P2, P0
cmp S1, P2
cmovg P2, S1
cmovle P0, S1
cmp P1, P3
cmovle P0, P3
