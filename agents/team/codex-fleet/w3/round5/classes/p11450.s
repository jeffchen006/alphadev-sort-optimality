# n=5 model=out iset=I1 prefix14_class=11450
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovle P3, S2
cmp P2, P0
mov S1, P3
mov S0, P0
cmovge S0, P2
cmovge P2, P0
cmp P2, P3
cmovge P3, P2
cmovg P2, S1
cmp S0, P1
mov P2, S0
