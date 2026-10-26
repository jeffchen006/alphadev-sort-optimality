# n=5 model=out iset=I1 prefix14_class=10690
mov S2, P3
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovle P0, S0
cmp P3, P1
cmovg P3, P1
cmovg P1, S2
cmovl S2, P1
cmp P0, S2
cmovle P1, P0
cmovl P0, S2
mov S2, P3
cmp S2, P2
