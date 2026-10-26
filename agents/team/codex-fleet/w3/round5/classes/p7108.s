# n=5 model=out iset=I1 prefix14_class=7108
mov S2, P2
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmp P1, P3
mov S0, P1
cmovge P1, P3
cmovl S0, P3
cmp S2, P0
mov P3, P0
