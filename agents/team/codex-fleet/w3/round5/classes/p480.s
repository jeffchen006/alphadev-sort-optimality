# n=5 model=out iset=I1 prefix14_class=480
cmp P2, P3
cmovle S0, P3
cmovg S0, P2
mov S1, P0
cmovle P3, P2
cmp S1, P1
cmovg P0, P1
cmovg P1, S1
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
cmovl P3, S1
mov P2, P3
cmp P1, S0
