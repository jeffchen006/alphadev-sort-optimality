# n=5 model=out iset=I1 prefix14_class=11900
mov S2, P3
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovge S1, P0
cmp P3, P2
cmovl S2, P2
mov S0, S1
cmovle P2, P3
cmp S0, S2
cmovge S1, S2
cmovg S2, S0
cmp P2, P1
cmovge S0, P1
