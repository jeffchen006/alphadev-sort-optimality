# n=5 model=out iset=I1 prefix14_class=4415
mov S1, P3
mov S2, P1
cmp S1, P0
cmovle P3, P0
cmovg S1, P0
cmp S2, P2
cmovge S2, P2
mov S0, S1
cmovge P2, P1
cmp P3, P2
cmovle P0, P3
cmovl P3, P2
cmovle P2, P0
mov P3, P2
