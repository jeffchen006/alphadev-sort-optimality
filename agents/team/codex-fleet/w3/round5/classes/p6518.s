# n=5 model=out iset=I1 prefix14_class=6518
mov S0, P2
cmp S0, P0
cmovg P2, P0
cmovg P0, S0
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
mov S1, P1
cmovl P0, S0
cmp P2, P1
