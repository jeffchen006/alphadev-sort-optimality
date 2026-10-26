# n=5 model=out iset=I1 prefix14_class=11961
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovge S0, P1
cmp P2, P3
cmovle P1, P2
mov S1, S0
cmovl P2, P3
cmovl P3, P1
cmp S0, P2
mov S2, P0
cmovle S0, P2
cmovg S1, P2
cmovl P2, S1
