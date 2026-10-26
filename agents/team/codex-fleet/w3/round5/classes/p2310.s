# n=5 model=out iset=I1 prefix14_class=2310
mov S0, P3
cmp P1, P0
mov S2, P1
cmovl P1, P0
cmovge S2, P0
cmp S0, P2
cmovle S0, P2
cmovg P3, P2
cmp S0, P1
cmovg P0, S0
cmovle P0, P1
cmovle P1, S0
cmp S2, P3
cmovg P2, P3
