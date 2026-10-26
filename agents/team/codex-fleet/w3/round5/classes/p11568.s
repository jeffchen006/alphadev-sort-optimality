# n=5 model=out iset=I1 prefix14_class=11568
cmp P0, P1
mov S0, P1
cmovle S0, P0
cmovg P1, P0
mov S1, P2
cmp P3, P2
cmovle P2, P3
mov S2, P1
cmovl P3, S1
cmp S0, P2
cmovl P0, P2
cmovl P2, S0
cmovl S0, P0
cmp P3, P1
