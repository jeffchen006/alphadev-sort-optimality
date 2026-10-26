# n=5 model=out iset=I1 prefix14_class=13958
mov S0, P0
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovg S2, P3
cmp P2, P0
cmovl P0, P2
cmovg S0, P2
cmp S0, P1
cmovle P2, P1
cmovl P1, S0
cmovl S0, P2
cmp P0, S2
cmovle P3, P0
