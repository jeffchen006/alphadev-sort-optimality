# n=5 model=out iset=I1 prefix14_class=7701
mov S0, P2
mov S2, P3
cmp P1, P3
cmovge P3, P1
cmovle S2, P1
cmp P0, P2
cmovl P2, P0
cmovg S0, P0
cmp S2, P2
mov S1, S2
cmovle S2, P2
cmovge S1, P2
cmp P3, S0
cmovle P1, P3
