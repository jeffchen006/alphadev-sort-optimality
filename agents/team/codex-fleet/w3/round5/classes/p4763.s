# n=5 model=out iset=I1 prefix14_class=4763
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovle P3, S2
mov S0, P0
cmp S0, P2
cmovl S0, P2
mov S1, P3
cmovg P0, P2
cmp P0, P3
cmovg P3, P0
cmovg P0, S1
cmp S0, P1
cmovl S2, S0
