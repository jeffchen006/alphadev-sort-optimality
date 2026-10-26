# n=5 model=out iset=I1 prefix14_class=11028
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovg P2, P1
cmp P0, P3
cmovl P1, P0
mov S0, S2
cmovl P0, P3
cmovl P3, P1
cmp P0, S0
cmovg S2, P0
cmovl S0, P0
cmp P2, P3
cmovle P0, P3
