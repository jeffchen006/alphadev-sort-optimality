# n=5 model=out iset=I1 prefix14_class=5954
cmp P2, P3
cmovg S0, P3
cmovle S0, P2
cmovge P3, P2
mov P2, P1
cmp P2, P0
cmovge P1, P0
mov S2, P3
cmovle P2, P0
cmp P3, P2
cmovle P3, P2
cmovge S2, P2
cmp S0, P1
mov P3, P1
