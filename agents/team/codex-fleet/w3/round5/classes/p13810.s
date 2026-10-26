# n=5 model=out iset=I1 prefix14_class=13810
mov S1, P0
cmp P1, S1
cmovle S1, P1
cmovle P1, P0
cmp P3, P2
cmovl S2, P2
mov S0, P1
cmovge S2, P3
cmovl P2, P3
cmp S2, P1
cmovle P1, S2
cmovge S0, S2
cmp P2, S1
cmovle P0, S1
