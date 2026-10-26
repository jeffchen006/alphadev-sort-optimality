# n=5 model=out iset=I1 prefix14_class=10867
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P3, P0
cmovle S2, P0
cmovg S2, P3
mov S0, S2
cmovl P0, P3
cmp S2, P1
cmovge S0, P1
cmovge P1, S2
cmp P2, P0
cmovl S2, P0
