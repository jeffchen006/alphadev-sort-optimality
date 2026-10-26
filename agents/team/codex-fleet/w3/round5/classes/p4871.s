# n=5 model=out iset=I1 prefix14_class=4871
cmp P2, P0
mov S2, P3
cmovg S0, P0
cmovle S0, P2
cmovg P0, P2
cmp P1, P3
cmovle P3, P1
cmovg S2, P1
cmp P3, S0
mov P2, P3
cmovle P2, S0
cmovg P3, S0
cmp S2, P0
cmovge S1, P0
