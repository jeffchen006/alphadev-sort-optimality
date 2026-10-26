# n=5 model=out iset=I1 prefix14_class=5620
mov S2, P2
cmp P2, P0
cmovg S2, P0
cmovl P2, P0
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S2, P1
cmovge S0, S2
cmovg S2, P1
cmovge P1, S0
mov S0, P2
cmp S0, P3
