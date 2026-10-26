# n=5 model=out iset=I1 prefix14_class=1294
cmp P2, P3
mov S1, P3
mov S0, P1
cmovg P3, P2
cmovg P2, S1
cmp S0, P0
mov S2, P3
cmovl P1, P0
cmovle P0, S0
cmp P3, P1
cmovle S2, P1
cmovg P3, P1
cmp P2, P0
cmovge S2, P2
