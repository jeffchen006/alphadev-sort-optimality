# n=5 model=out iset=I1 prefix14_class=3110
cmp P1, P0
mov S2, P0
mov S0, P3
cmovl P0, P1
cmovg S2, P1
cmp P2, P3
cmovg P3, P2
cmovl S0, P2
mov P2, P0
cmp P0, S0
cmovle P2, S0
cmovg P0, S0
mov P0, P2
mov S0, P3
