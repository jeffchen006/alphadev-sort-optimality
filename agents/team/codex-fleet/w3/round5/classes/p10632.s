# n=5 model=out iset=I1 prefix14_class=10632
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovg S1, P2
mov S2, P1
cmp S2, P3
cmovge P1, P3
cmovle S2, P3
cmp S2, P0
cmovle P3, S2
cmovl S2, P0
cmovle P0, P3
cmp P1, S1
cmovge S0, S1
