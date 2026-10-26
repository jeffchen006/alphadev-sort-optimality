# n=5 model=out iset=I1 prefix14_class=574
cmp P3, P2
mov S1, P2
cmovg S1, P3
cmovle P2, P3
cmovle P3, S1
mov S2, P2
cmp P0, P1
mov S0, P1
cmovge S0, P0
cmovle P1, P0
cmp S0, P3
cmovge S1, S0
cmovle P3, S0
cmp P1, P2
