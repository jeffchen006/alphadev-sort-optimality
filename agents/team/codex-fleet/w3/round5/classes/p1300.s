# n=5 model=out iset=I1 prefix14_class=1300
mov S2, P2
cmp S2, P0
cmovl S2, P0
cmovg P2, P0
mov S0, P3
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
mov P0, P3
cmp P0, S2
cmovg P0, S2
cmovl P3, S2
cmovle S2, P0
cmp P1, P2
