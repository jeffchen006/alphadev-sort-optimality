# n=5 model=out iset=I1 prefix14_class=9073
cmp P3, P1
mov S0, P1
cmovg P1, P3
mov S2, P2
cmovl S0, P3
cmp S2, P0
cmovl S2, P0
mov P3, S0
cmovl P0, P2
cmp S2, P1
cmovle P2, S2
cmovl S2, P1
cmovle P1, P2
mov S2, P1
