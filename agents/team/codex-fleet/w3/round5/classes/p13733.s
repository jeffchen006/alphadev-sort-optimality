# n=5 model=out iset=I1 prefix14_class=13733
mov S2, P0
cmp P1, P3
mov S1, P3
cmovl P3, P1
cmovle P1, S1
cmp S2, P2
cmovg S2, P2
cmovle P0, P2
cmp P0, P1
cmovg P2, P1
cmovg P1, P0
cmovg P0, P2
mov S0, P3
cmp P3, S2
