# n=5 model=out iset=I1 prefix14_class=4996
cmp P0, P1
mov S0, P1
cmovg S0, P0
cmovl P1, P0
mov P0, S0
mov S2, P2
cmp P3, S2
cmovg P2, P3
cmovl S2, P3
cmp S2, P1
cmovle P3, P1
cmovle P1, S2
cmovle S2, P3
cmp S0, P2
