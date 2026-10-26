# n=5 model=out iset=I1 prefix14_class=13572
cmp P0, P1
mov S2, P0
cmovle S2, P1
cmovle P1, P0
mov P0, P2
cmp P3, P2
cmovle P0, P3
cmovle P3, P2
cmp P1, P0
cmovge P2, P0
mov S0, P3
cmovg P0, P1
cmovge P1, P2
cmp S0, S2
