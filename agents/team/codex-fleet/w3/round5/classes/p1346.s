# n=5 model=out iset=I1 prefix14_class=1346
cmp P0, P2
mov S1, P1
mov S0, P2
cmovle S0, P0
cmovg P2, P0
cmp P3, P1
cmovle S1, P3
mov S2, P2
cmovg P1, P3
cmp P1, S2
cmovge S2, P1
mov S2, S1
cmovle P2, P1
cmp S1, S0
