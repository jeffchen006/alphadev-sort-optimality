# n=5 model=out iset=I1 prefix14_class=8514
cmp P0, P3
cmovl S0, P3
mov S1, P2
cmovle P3, P0
cmovl P0, S0
cmp S1, P1
cmovl P2, P1
cmovl P1, S1
cmovle S1, P2
cmp P0, P2
cmovle P2, P0
cmovg S1, P0
cmp P3, P1
mov P0, P3
