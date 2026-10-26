# n=5 model=out iset=I1 prefix14_class=13960
mov S0, P0
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovg S2, P3
cmp P2, S0
cmovl S0, P2
cmovg P0, P2
cmp P0, P1
cmovle P3, P1
cmovl P1, P0
cmovle P0, P3
cmp S0, S2
cmovle S1, S0
