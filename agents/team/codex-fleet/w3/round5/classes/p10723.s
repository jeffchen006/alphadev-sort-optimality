# n=5 model=out iset=I1 prefix14_class=10723
mov S2, P0
cmp P2, P0
cmovl P0, P2
cmovle P2, S2
mov S1, P3
mov S0, P2
cmp P3, P1
cmovle P3, P1
cmovle P1, S1
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmp P0, P1
cmovl S1, P1
