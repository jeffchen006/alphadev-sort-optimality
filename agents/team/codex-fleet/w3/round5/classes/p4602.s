# n=5 model=out iset=I1 prefix14_class=4602
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P1, P2
cmovle S2, P2
cmovl P2, P1
cmovle P1, S2
mov P3, S1
cmp P1, S1
cmovl S1, P1
cmovle P1, P3
mov S0, P2
cmp P0, S0
