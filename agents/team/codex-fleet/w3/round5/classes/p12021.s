# n=5 model=out iset=I1 prefix14_class=12021
cmp P0, P1
cmovle S2, P0
cmovge S2, P1
cmovge P1, P0
mov P0, P2
cmp P2, P3
cmovge P0, P3
cmovle P2, P3
mov S0, P1
cmp S2, P0
cmovle P3, S2
cmovl S2, P0
cmovle P0, P3
mov S1, S2
