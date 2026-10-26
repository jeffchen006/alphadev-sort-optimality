# n=5 model=out iset=I1 prefix14_class=8738
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovg P2, P0
cmp P1, P3
cmovle S0, P3
cmovge S0, P1
cmovle P3, P1
cmp S1, S0
cmovle S2, S0
cmovle S0, S1
mov P0, S0
cmovle S1, S2
cmp P2, P3
