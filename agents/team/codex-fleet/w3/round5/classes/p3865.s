# n=5 model=out iset=I1 prefix14_class=3865
cmp P1, P0
mov S2, P2
mov S1, P0
cmovl S1, P1
cmovge P0, P1
cmp S2, P3
cmovle S2, P3
cmovle P3, P2
cmp S1, P3
mov S0, S1
cmovle S1, P3
cmovle P3, S0
cmp S2, P0
cmovle P2, P0
