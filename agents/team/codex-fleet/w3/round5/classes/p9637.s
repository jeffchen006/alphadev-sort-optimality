# n=5 model=out iset=I1 prefix14_class=9637
cmp P3, P2
mov S0, P3
cmovg P3, P2
cmovg P2, S0
mov S0, P1
cmp S0, P0
cmovl P1, P0
cmovg S0, P0
cmp P1, P2
cmovle P0, P1
cmovl P1, P2
cmovle P2, P0
mov P1, P3
cmp P3, S0
