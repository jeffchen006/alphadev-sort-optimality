# n=5 model=out iset=I1 prefix14_class=4708
cmp P2, P1
cmovge S0, P1
cmovl S0, P2
cmovle P2, P1
mov S2, P3
cmp P3, P0
cmovge P3, P0
cmovle S2, P0
mov S1, P2
cmp S2, P2
cmovge S1, S2
cmovg S2, P2
cmp P3, S0
cmovg S1, P3
