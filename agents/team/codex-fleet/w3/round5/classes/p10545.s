# n=5 model=out iset=I1 prefix14_class=10545
mov S1, P1
cmp S1, P3
mov S0, P0
cmovl P1, P3
cmovle P3, S1
cmp P2, S0
cmovl P0, P2
cmovg S0, P2
cmp S0, P1
cmovl S1, S0
cmovle S0, P1
cmovl P1, S1
cmp P0, P3
mov S0, P3
