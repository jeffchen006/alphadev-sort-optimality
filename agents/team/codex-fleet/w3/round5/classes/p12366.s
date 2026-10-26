# n=5 model=out iset=I1 prefix14_class=12366
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P0, P2
cmovle S0, P2
cmovg S0, P0
cmovg P0, P2
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
mov S2, P3
mov P0, S0
