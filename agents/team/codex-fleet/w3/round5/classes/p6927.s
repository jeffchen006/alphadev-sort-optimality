# n=5 model=out iset=I1 prefix14_class=6927
cmp P0, P2
mov S0, P0
cmovl S0, P2
mov S1, P1
cmovg P0, P2
cmp P1, P3
cmovl P1, P3
cmovl P3, S1
cmp P1, S0
mov P2, P3
cmovle S2, S0
cmovl S0, P1
cmovle P1, S2
mov P1, S0
