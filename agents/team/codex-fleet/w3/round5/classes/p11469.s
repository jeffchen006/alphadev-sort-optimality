# n=5 model=out iset=I1 prefix14_class=11469
cmp P1, P3
mov S2, P2
mov S0, P1
cmovle P1, P3
cmovle P3, S0
cmp P2, P0
cmovl P2, P0
cmovl P0, S2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov P3, P1
cmovl P0, S0
cmp P2, P1
