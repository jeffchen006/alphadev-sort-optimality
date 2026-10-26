# n=5 model=out iset=I1 prefix14_class=4127
mov S1, P1
mov S0, P0
cmp P3, S0
cmovg S0, P3
cmovle P0, P3
cmp P2, S1
cmovle S1, P2
cmovg P1, P2
cmp S1, P0
mov P3, P0
cmovg P0, S1
cmovg S1, P3
cmp P1, S0
cmovge S2, S0
