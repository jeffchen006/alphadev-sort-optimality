# n=5 model=out iset=I1 prefix14_class=11260
mov S1, P2
cmp P2, P3
cmovge S1, P3
cmovle P2, P3
mov S2, P0
cmp P1, P0
cmovg S2, P1
cmovg P1, P0
cmp S2, P2
cmovge S0, S2
cmovle S0, P2
cmovle P2, S2
cmp P1, S1
cmovge S2, P2
