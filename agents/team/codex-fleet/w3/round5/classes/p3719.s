# n=5 model=out iset=I1 prefix14_class=3719
mov S0, P1
cmp P3, P0
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
cmp S0, P2
cmovle P1, P2
cmovle P2, S0
cmp P0, P2
mov S0, P0
cmovle S0, P2
cmovle P2, P0
cmp P1, P3
cmovg P2, P3
