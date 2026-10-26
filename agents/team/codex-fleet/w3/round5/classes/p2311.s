# n=5 model=out iset=I1 prefix14_class=2311
mov S2, P1
mov S0, P3
cmp P1, P0
cmovl P1, P0
cmovg S2, P0
cmp P3, P2
cmovle P3, P2
cmovge S0, P2
cmp P3, P1
cmovg S1, P3
cmovle S1, P1
cmovl P1, P3
cmp S2, S0
mov P3, P1
