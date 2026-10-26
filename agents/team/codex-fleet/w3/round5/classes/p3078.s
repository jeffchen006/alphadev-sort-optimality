# n=5 model=out iset=I1 prefix14_class=3078
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
cmovle P0, P3
cmp S0, P1
mov P3, P0
cmovge S1, S0
cmovg S0, P1
cmovg P1, S1
mov S0, P1
