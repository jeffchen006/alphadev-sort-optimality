# n=5 model=out iset=I1 prefix14_class=415
mov S1, P3
cmp P0, P3
mov S0, P2
cmovl P3, P0
cmovg S1, P0
cmp P2, P1
cmovg S0, P1
cmovg P1, P2
cmp P3, S0
cmovle P0, P3
cmovl P3, S0
cmovg P0, S0
cmp S1, P1
cmovg S2, P1
