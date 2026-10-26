# n=5 model=out iset=I1 prefix14_class=337
mov S1, P2
cmp S1, P3
cmovge S1, P3
cmovge P3, P2
cmp P1, P0
cmovle P2, P1
cmovg P2, P0
cmovg P0, P1
mov P1, P2
cmp S1, P1
cmovle P1, S1
cmovle S1, P2
cmp P0, P3
cmovle S0, P3
