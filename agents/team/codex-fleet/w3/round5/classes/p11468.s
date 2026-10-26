# n=5 model=out iset=I1 prefix14_class=11468
cmp P1, P3
mov S2, P2
mov S0, P1
cmovle P1, P3
cmovle P3, S0
cmp S2, P0
cmovl S2, P0
cmovl P0, P2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov S1, P1
cmovl P0, S0
cmp S2, P1
