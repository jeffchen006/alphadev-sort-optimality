# n=5 model=out iset=I1 prefix14_class=1144
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
cmovl P1, S2
cmp P3, P0
mov S0, P0
cmovge S0, P3
cmovg P3, P0
cmp S0, P2
cmovle P0, P2
cmovle P2, S0
cmovg P0, S0
mov S0, P3
cmp P1, S0
