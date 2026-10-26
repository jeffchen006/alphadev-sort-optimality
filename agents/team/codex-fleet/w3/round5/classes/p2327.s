# n=5 model=out iset=I1 prefix14_class=2327
mov S0, P1
mov S1, P3
cmp P1, P2
cmovle P1, P2
cmovg S0, P2
cmp S1, P0
cmovl P3, P0
cmovge S1, P0
cmp P1, P3
cmovle S2, P3
cmovg S2, P1
cmovle P3, P1
cmp S1, S0
cmovl P0, S0
