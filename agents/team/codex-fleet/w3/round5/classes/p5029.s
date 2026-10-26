# n=5 model=out iset=I1 prefix14_class=5029
cmp P0, P1
mov S2, P3
cmovle S0, P1
cmovle P1, P0
cmovg S0, P0
cmp P3, P2
cmovg S2, P2
cmovl P3, P2
cmp P1, S2
mov S1, P1
cmovle S1, S2
cmovg P1, S2
mov P1, S0
mov S2, S1
