# n=5 model=out iset=I1 prefix14_class=7983
cmp P3, P0
mov S0, P3
cmovle S0, P0
cmovl P0, P3
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
mov P3, P2
cmovl P1, S1
cmp P0, P2
cmovle P2, P0
cmovl P0, P3
cmp P1, S0
mov P3, S0
