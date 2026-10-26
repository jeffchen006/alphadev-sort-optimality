# n=5 model=out iset=I1 prefix14_class=13583
mov S2, P3
cmp P1, P0
cmovge S0, P0
cmovle S0, P1
cmovle P1, P0
cmp P2, S2
cmovge S2, P2
cmovle P3, P2
mov S1, P1
cmp P3, S0
cmovg P2, P3
cmovg P3, S0
cmovg S0, P2
cmp S1, S2
