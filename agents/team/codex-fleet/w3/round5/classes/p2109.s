# n=5 model=out iset=I1 prefix14_class=2109
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovle P3, P1
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovg P0, P2
mov S2, S1
cmp S0, S1
cmovg S1, S0
mov S1, P0
cmovge S0, S2
cmp S1, P3
