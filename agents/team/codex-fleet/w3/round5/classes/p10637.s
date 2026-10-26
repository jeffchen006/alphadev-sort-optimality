# n=5 model=out iset=I1 prefix14_class=10637
mov S0, P1
cmp S0, P0
cmovg S0, P0
cmovl P1, P0
cmp P2, P3
mov P0, P3
cmovle P0, P2
cmovle P2, P3
cmovg P3, P2
cmp P3, P1
cmovg P2, P1
cmovle P3, P1
mov P3, P0
cmp S0, P0
