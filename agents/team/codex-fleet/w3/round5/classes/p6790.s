# n=5 model=out iset=I1 prefix14_class=6790
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
mov S1, P1
cmovle P2, S2
cmp S1, P0
cmovg P1, P0
cmovl S1, P0
cmp S1, P3
mov S0, P2
mov P0, P3
cmovge P3, S1
cmovle P0, S1
cmp P1, S0
