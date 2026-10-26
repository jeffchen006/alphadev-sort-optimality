# n=5 model=out iset=I1 prefix14_class=9415
mov S0, P0
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
mov S1, P2
cmp P1, S1
cmovle S1, P1
cmovl P1, P2
mov S2, S1
cmp S1, P3
cmovge S1, P3
cmovg P3, S2
cmp P1, S0
cmovl P2, S0
