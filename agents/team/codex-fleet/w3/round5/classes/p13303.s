# n=5 model=out iset=I1 prefix14_class=13303
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovle P2, S2
mov S1, P3
cmp P1, S1
cmovle S1, P1
cmovle P1, P3
cmp S1, P2
cmovge S0, S1
cmovge S1, P2
cmovg P2, S0
mov S2, P1
cmp P1, P0
