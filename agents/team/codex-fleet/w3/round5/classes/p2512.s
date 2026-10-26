# n=5 model=out iset=I1 prefix14_class=2512
mov S1, P2
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovl P1, S0
cmp P3, P2
cmovl P2, P3
cmovge S1, P3
mov S2, P1
cmp S2, S1
cmovg P1, S1
cmovle S2, S1
cmp P2, P0
mov S1, P2
