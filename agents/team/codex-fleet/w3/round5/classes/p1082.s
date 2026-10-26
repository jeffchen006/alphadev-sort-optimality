# n=5 model=out iset=I1 prefix14_class=1082
cmp P1, P0
mov S0, P2
cmovge S1, P1
cmovle S1, P0
cmovle P0, P1
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmp S1, P3
cmovge P2, P3
cmovge P3, S1
cmovle P2, S1
mov P3, P0
cmp S0, P3
