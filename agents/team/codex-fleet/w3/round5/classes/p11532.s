# n=5 model=out iset=I1 prefix14_class=11532
mov S2, P2
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
mov S0, P1
cmp P1, S2
cmovg S0, S2
cmovg S2, P1
cmp P3, P0
mov P1, P0
