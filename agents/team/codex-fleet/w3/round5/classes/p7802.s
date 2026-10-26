# n=5 model=out iset=I1 prefix14_class=7802
mov S0, P3
cmp S0, P1
cmovg P3, P1
cmovle S0, P1
cmp P0, P2
cmovge S1, P0
mov P1, P3
cmovge P0, P2
cmovge P2, S1
cmp P0, P1
cmovle P1, P0
cmovge P3, P0
cmp S0, P2
cmovle S1, S0
