# n=5 model=out iset=I1 prefix14_class=7986
cmp P0, P3
mov S0, P3
cmovg S0, P0
mov S2, P1
cmovl P3, P0
cmp P2, S2
cmovl S2, P2
cmovle P2, P1
mov S1, S2
cmp P3, S1
cmovle S2, P3
cmovle P3, S1
cmp P2, S0
cmovl P0, S0
