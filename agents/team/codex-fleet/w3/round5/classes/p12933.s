# n=5 model=out iset=I1 prefix14_class=12933
cmp P2, P1
mov S0, P1
cmovl P1, P2
cmovg S0, P2
cmp P3, P0
mov P2, P0
cmovg P2, P3
cmovle P0, P3
cmovg P3, P0
cmp P0, P1
cmovl P0, P1
cmovg P3, P1
cmp P2, S0
cmovl S2, S0
