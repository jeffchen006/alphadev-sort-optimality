# n=5 model=out iset=I1 prefix14_class=7804
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovle S0, P3
cmp P0, P1
mov P3, P2
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
cmp P0, P3
cmovle P3, P0
cmovg P2, P0
cmp S0, P1
cmovle S1, S0
