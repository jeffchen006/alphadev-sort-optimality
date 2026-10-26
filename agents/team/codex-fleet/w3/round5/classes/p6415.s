# n=5 model=out iset=I1 prefix14_class=6415
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
mov S2, P1
cmovge P3, S0
cmp P0, P1
cmovle P1, P0
cmovge S2, P0
cmovl P0, S2
cmp P3, S2
cmovl P0, P3
cmovg S2, P3
cmp P1, P2
mov S2, P1
