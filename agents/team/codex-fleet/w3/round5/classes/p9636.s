# n=5 model=out iset=I1 prefix14_class=9636
cmp P0, P2
mov S0, P0
cmovg P0, P2
cmovg P2, S0
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovg S0, P3
cmp P1, P2
cmovle P3, P1
cmovle P1, P2
cmovle P2, P3
mov P1, P0
cmp P0, S0
