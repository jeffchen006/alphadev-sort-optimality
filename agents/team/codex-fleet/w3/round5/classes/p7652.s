# n=5 model=out iset=I1 prefix14_class=7652
mov S2, P3
cmp P1, S2
cmovl P3, P1
mov S0, P2
cmovg S2, P1
cmp P0, S0
cmovg P2, P0
cmovle S0, P0
cmp P3, S0
cmovle P1, P3
mov S1, S2
cmovl P3, S0
cmovl S0, P1
cmp P2, S2
