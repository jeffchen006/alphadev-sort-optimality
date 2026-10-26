# n=5 model=out iset=I1 prefix14_class=3614
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
mov P1, P2
cmp P3, P1
cmovl P2, P3
cmovl P3, P1
mov P1, P2
cmp P0, P1
cmovle P1, P0
cmovl P0, P2
cmp P3, S0
mov P1, S0
