# n=5 model=out iset=I1 prefix14_class=1979
mov S0, P3
cmp P3, P1
cmovle P3, P1
cmovle P1, S0
mov S0, P1
mov S2, P0
cmp P2, S2
cmovl P0, P2
cmovge S2, P2
cmp S2, P3
cmovl P2, S2
cmovle S2, P3
cmovl P3, P2
cmp P1, P0
