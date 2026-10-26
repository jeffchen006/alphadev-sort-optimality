# n=5 model=out iset=I1 prefix14_class=1572
cmp P2, P0
cmovge S1, P0
mov S2, P3
cmovle S1, P2
cmovg P0, P2
cmp P1, P3
cmovge S2, P1
cmovle P3, P1
cmp S1, P3
cmovg S0, S1
mov P1, P0
cmovge S1, P3
cmovg P3, S0
cmp S2, P0
