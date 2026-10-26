# n=5 model=out iset=I1 prefix14_class=2816
cmp P3, P1
mov S0, P1
cmovle P1, P3
cmovl P3, S0
mov S1, P0
cmp P2, S1
cmovg P0, P2
cmovle S1, P2
cmp P3, P0
cmovl S0, P3
cmovl P3, P0
mov P2, S1
cmovl P0, S0
cmp S1, P1
