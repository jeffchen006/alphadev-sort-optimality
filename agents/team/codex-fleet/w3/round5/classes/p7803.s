# n=5 model=out iset=I1 prefix14_class=7803
mov S0, P2
cmp S0, P1
cmovg P2, P1
cmovle S0, P1
cmp P0, P3
cmovge S1, P0
mov P1, P2
cmovge P0, P3
cmovge P3, S1
cmp P0, P1
cmovle P1, P0
cmovg P2, P0
cmp S0, P3
cmovle S1, S0
