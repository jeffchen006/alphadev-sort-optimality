# n=5 model=out iset=I1 prefix14_class=7999
mov S1, P0
mov S0, P3
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
mov P3, S0
cmp S1, P2
cmovle S1, P2
cmovge P0, P2
cmp P0, S0
cmovge S0, P0
cmovle P3, P0
cmp S1, P1
cmovg P2, S1
