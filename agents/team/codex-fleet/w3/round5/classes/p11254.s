# n=5 model=out iset=I1 prefix14_class=11254
cmp P1, P0
cmovle S0, P0
cmovge S0, P1
cmovge P1, P0
cmp P3, P2
mov P0, P3
mov S1, S0
cmovg P3, P2
cmovle P0, P2
cmp S1, P0
cmovge S0, P0
cmovle S1, P0
cmp P1, P3
cmovg S1, P3
