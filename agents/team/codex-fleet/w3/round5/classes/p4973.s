# n=5 model=out iset=I1 prefix14_class=4973
mov S1, P1
cmp P1, P0
cmovg P1, P0
mov S2, P1
cmovle S1, P0
mov S0, P2
cmp S0, P3
cmovle S0, P3
cmovg P2, P3
cmp P2, P1
cmovle P1, P2
cmovle P2, S2
mov P1, S0
cmovge S2, P2
