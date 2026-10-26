# n=5 model=out iset=I1 prefix14_class=390
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
mov S2, P3
cmovle P1, P2
cmp S2, P0
cmovge P3, P0
cmovg P0, S2
mov S0, P3
cmp S0, P1
cmovle S0, P1
cmovge P3, P1
cmp S1, P0
cmovle S2, P0
