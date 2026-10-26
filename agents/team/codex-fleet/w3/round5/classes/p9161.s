# n=5 model=out iset=I1 prefix14_class=9161
mov S2, P3
cmp P0, P3
cmovle S2, P0
cmovg P3, P0
cmp P2, P1
mov P0, P1
cmovle P1, P2
cmovle P2, P0
mov S0, P3
cmp S2, P1
cmovge P0, S2
cmovge S2, P1
cmovge P1, P0
cmp P2, S0
