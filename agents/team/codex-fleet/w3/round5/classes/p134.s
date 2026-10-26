# n=5 model=out iset=I1 prefix14_class=134
mov S1, P3
mov S0, P2
cmp S1, P0
cmovge S1, P0
cmovle P3, P0
cmp P1, S0
cmovl P2, P1
cmovg S0, P1
mov S2, S1
cmp P2, S1
cmovle S2, P2
cmovl P2, S1
mov S1, S0
cmp P3, S1
