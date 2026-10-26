# n=5 model=out iset=I1 prefix14_class=12254
mov S0, P3
cmp P0, S0
cmovle P3, P0
cmovle P0, S0
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmp S1, P3
cmovle P1, S1
cmovle S1, P3
cmovle P3, P1
cmp P0, P2
cmovg S0, P2
