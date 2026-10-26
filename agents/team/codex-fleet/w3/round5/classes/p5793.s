# n=5 model=out iset=I1 prefix14_class=5793
cmp P1, P3
mov S0, P1
cmovl S0, P3
cmovle P3, P1
cmovg P1, P3
cmp P2, P0
mov S1, P2
cmovg P2, P0
cmovg P0, S1
cmp P1, P2
cmovl P3, P2
cmovl P2, P1
cmp S0, P0
cmovle S1, P0
