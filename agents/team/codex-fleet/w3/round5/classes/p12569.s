# n=5 model=out iset=I1 prefix14_class=12569
mov S2, P2
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, S2
cmovl S2, P1
mov S1, P0
cmovle P1, P2
cmp P0, S2
cmovg S1, S2
cmovle P0, S2
cmp P1, P3
cmovle S0, P1
