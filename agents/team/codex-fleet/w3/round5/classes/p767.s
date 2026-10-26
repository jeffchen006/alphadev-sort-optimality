# n=5 model=out iset=I1 prefix14_class=767
mov S1, P1
cmp P0, P1
cmovl S1, P0
mov S0, P3
cmovl P0, P1
cmp S0, P2
cmovg S0, P2
cmovl P3, P2
cmp P3, P0
cmovle P1, P0
cmovg P1, P3
cmovl P0, P3
mov P1, S1
cmp P1, S0
