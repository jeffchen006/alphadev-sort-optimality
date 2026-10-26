# n=5 model=out iset=I1 prefix14_class=698
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
cmovle P3, P1
mov P1, P0
mov S1, P3
cmp P1, P2
cmovg P1, P2
cmovl P0, P2
cmp P3, P0
cmovl P3, P0
cmovle P0, S1
mov S1, S0
mov S2, P0
