# n=5 model=out iset=I1 prefix14_class=10759
cmp P2, P0
cmovg S0, P0
cmovle S0, P2
cmovge P0, P2
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
mov S1, P3
cmovl P1, S2
cmp P3, P0
cmovle P3, P0
cmovle P0, S1
cmp S0, P1
cmovge S1, P1
