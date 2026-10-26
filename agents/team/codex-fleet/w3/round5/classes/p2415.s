# n=5 model=out iset=I1 prefix14_class=2415
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
cmovle S1, P3
mov P3, S1
mov S0, P0
cmp P1, S0
cmovle P0, P1
cmovge S0, P1
cmp P3, S0
cmovg S1, S0
cmovl P3, S0
cmp P2, P0
cmovl S0, P0
