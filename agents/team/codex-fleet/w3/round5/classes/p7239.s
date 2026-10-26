# n=5 model=out iset=I1 prefix14_class=7239
cmp P0, P1
mov S2, P1
cmovle P1, P0
mov S0, P1
cmovge S2, P0
mov S1, P3
cmp P2, S1
cmovle S1, P2
cmovg P3, P2
cmp S1, S0
cmovle P1, S1
cmovge S0, S1
mov P0, S0
mov P1, P3
