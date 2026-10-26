# n=5 model=out iset=I1 prefix14_class=6664
mov S0, P0
cmp P3, S0
mov S2, P2
cmovle P0, P3
cmovle P3, S0
cmp S2, P1
cmovle P2, P1
cmovge S2, P1
mov S1, P3
cmp S1, P2
cmovg P3, P2
cmovg P2, S1
cmovge S1, P3
cmp S2, P0
