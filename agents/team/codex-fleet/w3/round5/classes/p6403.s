# n=5 model=out iset=I1 prefix14_class=6403
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
mov S0, P3
cmp P0, P3
cmovg S0, P0
cmovl P3, P0
cmovl P0, S0
cmp P1, P0
cmovg S0, P1
cmovl P0, P1
mov S0, P0
mov P1, P3
