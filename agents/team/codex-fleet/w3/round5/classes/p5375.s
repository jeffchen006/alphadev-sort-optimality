# n=5 model=out iset=I1 prefix14_class=5375
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
mov S0, P0
cmovl P2, S2
mov S1, P3
cmp P1, S0
cmovl P0, P1
cmovl P1, S0
cmp P0, P3
cmovl P3, P0
mov P3, P2
cmovg S1, P0
cmp P2, P1
