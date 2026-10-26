# n=5 model=out iset=I1 prefix14_class=12614
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovl P1, P3
cmp P2, P0
cmovle P3, P0
cmovle P0, P2
cmovle P2, P3
cmp P0, S0
cmovle P3, S0
cmovl S0, P0
cmovle P0, P3
mov S0, P1
cmp P2, P1
