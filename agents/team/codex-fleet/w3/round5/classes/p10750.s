# n=5 model=out iset=I1 prefix14_class=10750
mov S0, P3
cmp P2, S0
cmovl P3, P2
cmovg S0, P2
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
mov P2, P0
cmovl P1, S2
cmp P2, S0
cmovle P2, S0
cmovl S0, P0
cmp P3, P1
mov P2, P1
