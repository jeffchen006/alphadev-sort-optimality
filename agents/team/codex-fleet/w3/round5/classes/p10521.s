# n=5 model=out iset=I1 prefix14_class=10521
cmp P3, P2
mov S2, P3
mov S0, P0
cmovge S2, P2
cmovle P3, P2
cmp P1, S0
cmovge S0, P1
cmovge P1, P0
cmp S0, P3
cmovle P2, P3
cmovl P3, S0
cmovle S0, P2
cmp P1, S2
cmovg S1, P1
