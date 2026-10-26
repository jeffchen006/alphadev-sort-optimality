# n=5 model=out iset=I1 prefix14_class=4523
mov S2, P3
cmp P3, P1
mov S1, P0
cmovl P3, P1
cmovge S2, P1
cmp S1, P2
cmovg S1, P2
cmovle P0, P2
mov S0, P0
cmp P0, P3
cmovg P0, P3
cmovg P3, S0
cmp S2, S1
cmovle P1, S2
