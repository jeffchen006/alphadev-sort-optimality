# n=5 model=out iset=I1 prefix14_class=10918
cmp P0, P2
cmovg S0, P2
cmovle S0, P0
cmovg P2, P0
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmovl P1, S2
cmp P3, P2
mov P0, P3
cmovl P3, P2
cmovle P2, P0
cmp S0, P1
cmovl P0, P1
