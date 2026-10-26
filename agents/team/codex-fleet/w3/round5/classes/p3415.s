# n=5 model=out iset=I1 prefix14_class=3415
cmp P1, P2
mov S0, P1
cmovl S0, P2
cmovle P2, P1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
cmovle P1, P0
cmp P3, P2
cmovge S1, P2
cmovg P2, P3
cmovle S1, P3
mov S2, S0
mov P3, P2
