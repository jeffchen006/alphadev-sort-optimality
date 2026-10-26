# n=5 model=out iset=I1 prefix14_class=12590
cmp P2, P0
mov S2, P2
cmovl P2, P0
cmovge S2, P0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P3, S2
mov S0, S2
cmovle S0, P3
mov S0, P2
cmovl P3, S2
cmp S0, P1
