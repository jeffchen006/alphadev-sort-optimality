# n=5 model=out iset=I1 prefix14_class=6027
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovle P0, S0
mov S2, P2
cmp S2, P0
cmovge S2, P0
cmovg P0, P2
cmp P3, P1
cmovge S0, P1
