# n=5 model=out iset=I1 prefix14_class=1308
mov S0, P2
mov S1, P0
cmp P0, P1
cmovge S1, P1
cmovle P0, P1
cmp S0, P3
cmovge P2, P3
cmovg P3, S0
mov S0, P0
cmp P3, S0
cmovg P0, P3
cmovge P3, S0
mov P1, S1
mov S0, P3
