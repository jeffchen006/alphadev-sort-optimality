# n=5 model=out iset=I1 prefix14_class=2821
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovle P0, S0
cmp P2, P3
cmovle S1, P2
cmovg S1, P3
cmovg P3, P2
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
mov P2, P1
cmovl P3, S2
cmp P1, S1
