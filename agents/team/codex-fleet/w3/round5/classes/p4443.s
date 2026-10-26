# n=5 model=out iset=I1 prefix14_class=4443
cmp P3, P1
mov S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
mov S1, S0
cmovl P2, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, S0
mov S0, P3
cmp S0, P2
