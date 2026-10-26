# n=5 model=out iset=I1 prefix14_class=9821
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
mov S2, P2
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
mov S0, P1
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
cmp P1, P0
