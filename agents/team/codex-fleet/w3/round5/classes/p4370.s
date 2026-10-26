# n=5 model=out iset=I1 prefix14_class=4370
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
mov S0, P0
cmovle P2, S2
cmp S0, P3
cmovle S0, P3
cmovg P0, P3
mov S1, P2
mov P3, P0
cmp P0, P1
cmovle P0, P1
cmovge P3, P1
cmp P2, S0
