# n=5 model=out iset=I1 prefix14_class=7819
mov S2, P3
cmp P1, P3
cmovge P3, P1
mov S1, P0
cmovle S2, P1
cmp P2, P0
cmovge S1, P2
cmovl P0, P2
cmp P0, S2
mov S0, P0
cmovg S0, S2
cmovle P0, S2
cmp S1, P3
cmovge S2, P0
