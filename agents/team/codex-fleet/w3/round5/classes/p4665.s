# n=5 model=out iset=I1 prefix14_class=4665
mov S1, P1
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovge P3, S0
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
mov P1, P0
cmp P2, P0
mov S2, S1
cmovg P0, P2
cmovge P2, P1
cmp S2, P3
