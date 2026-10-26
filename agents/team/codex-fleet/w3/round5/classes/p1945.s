# n=5 model=out iset=I1 prefix14_class=1945
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmovge S1, P2
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovle S2, P1
mov S0, P3
cmp P0, P3
cmovg S0, P0
cmovle P3, P0
cmp S2, S1
cmovge P2, S1
