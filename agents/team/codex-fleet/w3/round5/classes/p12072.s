# n=5 model=out iset=I1 prefix14_class=12072
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmovle S0, P2
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovle S1, P0
mov S2, P1
cmp P3, S2
cmovle P1, P3
cmovge S2, P3
cmovg P3, S1
cmp S0, S1
