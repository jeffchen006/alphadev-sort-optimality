# n=5 model=out iset=I1 prefix14_class=11006
mov S2, P3
cmp P3, P0
cmovle P3, P0
cmovg S2, P0
mov S0, P1
cmp P2, P1
cmovle P1, P2
cmovl P2, S0
cmp P2, P3
cmovl S0, P2
cmovl P2, P3
cmovl P3, S0
cmp S2, P1
cmovle S0, P1
