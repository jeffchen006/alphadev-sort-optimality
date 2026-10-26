# n=5 model=out iset=I1 prefix14_class=10580
mov S2, P2
mov S0, P3
cmp P3, P1
cmovl P3, P1
cmovle P1, S0
cmp P0, S2
cmovge P2, P0
cmovl S2, P0
cmp P2, P3
cmovl S0, P2
mov S1, P1
cmovle P2, P3
cmovl P3, S0
cmp S2, S1
