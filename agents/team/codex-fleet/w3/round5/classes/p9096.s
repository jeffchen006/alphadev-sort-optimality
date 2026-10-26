# n=5 model=out iset=I1 prefix14_class=9096
mov S1, P3
cmp P2, P0
cmovg S0, P0
cmovle S0, P2
cmovle P2, P0
cmp S1, P1
cmovg S1, P1
cmovle P3, P1
cmp S0, S1
cmovge S2, S1
cmovl S2, S0
mov S2, P2
cmovle S0, S1
cmovge S1, S0
