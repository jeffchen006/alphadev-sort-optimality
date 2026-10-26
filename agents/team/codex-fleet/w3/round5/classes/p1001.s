# n=5 model=out iset=I1 prefix14_class=1001
mov S2, P2
cmp P1, P2
cmovl P2, P1
mov S0, P3
cmovg S2, P1
cmp P3, P0
cmovg P3, P0
cmovg P0, S0
mov S1, S2
cmp P0, S2
mov P1, P2
cmovg S1, P0
cmovg P0, S2
cmp P3, P1
