# n=5 model=out iset=I1 prefix14_class=7324
mov S0, P3
cmp P2, P3
cmovg S0, P2
cmovle P3, P2
cmp P1, P0
cmovge S2, P0
cmovl S2, P1
cmovle P1, P0
cmp S2, P3
cmovle S1, S2
cmovge S1, P3
cmovge P3, S2
cmp P1, S0
cmovg S2, P1
