# n=5 model=out iset=I1 prefix14_class=6375
cmp P3, P0
mov S2, P0
cmovle S2, P3
mov S1, P2
cmovg P0, P3
cmp P1, S1
cmovle P2, P1
cmovg S1, P1
mov S0, P0
cmp S1, S0
cmovle P0, S1
cmovg S0, S1
cmp P2, S2
cmovge S1, P2
