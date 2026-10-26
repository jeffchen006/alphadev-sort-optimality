# n=5 model=out iset=I1 prefix14_class=8493
cmp P0, P3
mov S1, P0
mov S0, P2
cmovge S1, P3
cmovg P3, P0
mov P0, P3
cmp S0, P1
cmovle P2, P1
cmovle P1, S0
cmp P3, P2
cmovle P0, P2
cmovg P3, P2
cmp S1, P1
cmovle P2, P1
