# n=5 model=out iset=I1 prefix14_class=3814
mov S1, P2
cmp S1, P1
cmovg P2, P1
cmovg P1, S1
mov S0, P3
cmp P0, P3
cmovle P3, P0
cmovl P0, S0
cmp P3, P2
mov S2, P0
mov S1, P3
cmovl P3, P2
cmovl P2, S1
mov P2, P3
