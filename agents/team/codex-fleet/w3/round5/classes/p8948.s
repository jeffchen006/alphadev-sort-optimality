# n=5 model=out iset=I1 prefix14_class=8948
cmp P0, P2
mov S2, P0
cmovg P0, P2
cmovle S2, P2
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovle P1, S0
cmp P3, S2
mov P2, P3
cmovg P3, S2
cmovle P2, S2
cmp P0, P1
cmovl S2, P1
