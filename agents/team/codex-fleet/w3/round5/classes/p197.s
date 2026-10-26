# n=5 model=out iset=I1 prefix14_class=197
mov S2, P0
mov S0, P2
cmp S2, P3
cmovl P0, P3
cmovle P3, S2
cmovl S2, P0
cmp S0, P1
cmovge S0, P1
cmovg P1, P2
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmovle S0, P2
cmp P0, P1
