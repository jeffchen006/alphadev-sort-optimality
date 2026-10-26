# n=5 model=out iset=I1 prefix14_class=4084
mov S0, P1
cmp P2, S0
cmovle P1, P2
cmovge S0, P2
mov S1, P1
cmp P0, P3
cmovle S2, P3
cmovge S2, P0
cmovg P0, P3
cmp S1, P0
cmovg P1, P0
cmovle S1, P0
cmp S0, S2
cmovge P0, S0
