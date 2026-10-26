# n=5 model=out iset=I1 prefix14_class=11033
mov S2, P0
cmp S2, P2
cmovle S2, P2
cmovl P2, P0
mov S1, P1
cmp S1, P3
mov S0, S2
cmovl S1, P3
cmovle P3, P1
cmp S1, S0
cmovle S0, S1
cmovge S2, S1
cmp P3, P2
cmovg S1, P2
