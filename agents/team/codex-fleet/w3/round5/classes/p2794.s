# n=5 model=out iset=I1 prefix14_class=2794
mov S1, P3
cmp P0, P3
cmovg S1, P0
mov S0, P1
cmovl P3, P0
cmp P2, P1
cmovl P1, P2
cmovl P2, S0
cmp P2, S1
cmovg S0, S1
cmovg S1, P2
cmovg P2, S0
cmp P3, P1
cmovg S0, P2
