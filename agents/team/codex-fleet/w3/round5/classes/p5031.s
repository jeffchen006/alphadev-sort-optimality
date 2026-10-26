# n=5 model=out iset=I1 prefix14_class=5031
cmp P0, P3
cmovle S0, P3
mov S1, P1
cmovge S0, P0
cmovle P3, P0
cmp S1, P2
cmovg S1, P2
cmovle P1, P2
cmp S1, P3
cmovg P0, S1
cmovle P0, P3
cmovg S1, P3
mov S1, P1
cmovg P3, P0
