# n=5 model=out iset=I1 prefix14_class=7704
cmp P1, P3
mov S2, P3
mov S0, P0
cmovle S2, P1
cmovle P1, P3
cmp P2, P0
cmovg S0, P2
cmovg P2, P0
cmp S2, P2
cmovl P0, P2
cmovl P2, S2
cmovl S2, P0
cmp P1, S0
mov P3, P1
