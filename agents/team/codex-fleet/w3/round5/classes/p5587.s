# n=5 model=out iset=I1 prefix14_class=5587
mov S0, P1
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
mov S0, P3
mov S2, P2
cmp S0, P0
cmovg S0, P0
cmovle P3, P0
cmp S0, S2
cmovle P2, S0
cmovge S2, S0
cmp P3, P1
cmovg P2, P3
