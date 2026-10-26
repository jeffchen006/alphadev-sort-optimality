# n=5 model=out iset=I1 prefix14_class=11531
mov S2, P2
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
mov S0, P3
cmp P3, S2
cmovg S0, S2
cmovg S2, P3
cmp P1, P0
mov P3, P0
