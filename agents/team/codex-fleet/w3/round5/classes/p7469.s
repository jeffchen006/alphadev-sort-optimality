# n=5 model=out iset=I1 prefix14_class=7469
cmp P2, P0
mov S0, P0
mov S1, P1
cmovg S0, P2
cmovl P0, P2
cmp P3, S1
cmovl S1, P3
cmovle P3, P1
cmp P0, S1
cmovle P1, P0
cmovle P0, S1
cmovle S1, P1
mov P2, P3
cmp S0, P3
