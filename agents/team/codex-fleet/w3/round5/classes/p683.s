# n=5 model=out iset=I1 prefix14_class=683
mov S0, P0
mov S2, P1
cmp P3, P0
cmovle P0, P3
cmovle P3, S0
cmp S2, P2
mov S0, P3
cmovl P1, P2
cmovg S2, P2
cmp P3, P1
cmovl P3, P1
cmovl P1, S0
cmp P0, S2
mov S0, P0
