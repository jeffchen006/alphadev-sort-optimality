# n=5 model=out iset=I1 prefix14_class=418
mov S1, P3
cmp P0, P3
mov S0, P2
cmovl P3, P0
cmovg S1, P0
cmp S0, P1
cmovge S0, P1
cmovge P1, P2
cmp P3, S0
cmovle S2, P3
cmovle P3, S0
cmovg S2, S0
cmp S1, P1
mov S2, P1
