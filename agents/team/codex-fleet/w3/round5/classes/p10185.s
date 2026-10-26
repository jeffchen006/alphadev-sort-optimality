# n=5 model=out iset=I1 prefix14_class=10185
mov S2, P3
mov S1, P2
cmp P1, P3
cmovl P3, P1
cmovg S2, P1
cmp S1, P0
cmovge S1, P0
cmovge P0, P2
cmp S2, P0
cmovle S0, P0
cmovg S0, S2
cmovle P0, S2
cmp S1, P3
cmovle S0, P3
