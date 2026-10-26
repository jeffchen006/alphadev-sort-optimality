# n=5 model=out iset=I1 prefix14_class=8479
mov S0, P2
mov S1, P1
cmp P2, P0
cmovge S0, P0
cmovle P2, P0
cmp S1, P3
cmovle P1, P3
cmovle P3, S1
cmp P2, P1
mov S2, P1
cmovle P1, P2
cmovle P2, S2
cmp S0, P3
mov P2, P1
