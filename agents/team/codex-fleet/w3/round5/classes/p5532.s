# n=5 model=out iset=I1 prefix14_class=5532
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
mov S1, P1
cmovl P0, S2
mov S0, P0
cmp S1, P2
cmovle S1, P2
cmovg P1, P2
cmp P0, P1
cmovle P0, P1
cmovg S0, P1
cmp S1, P3
mov P1, S1
