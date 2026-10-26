# n=5 model=out iset=I1 prefix14_class=12549
mov S0, P3
cmp S0, P1
cmovle S0, P1
cmovl P1, P3
cmp P0, P2
cmovle P3, P0
mov S1, S0
cmovl P0, P2
cmovle P2, P3
cmp P2, P1
cmovge S2, P2
cmovle S2, P1
cmovg P2, P1
cmp S0, P0
