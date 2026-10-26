# n=5 model=out iset=I1 prefix14_class=2714
cmp P2, P1
cmovg S1, P2
cmovle S1, P1
cmovle P1, P2
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
mov S2, P0
cmp S1, S2
cmovl P0, S1
mov P2, P0
cmovl S1, S2
mov S1, P1
