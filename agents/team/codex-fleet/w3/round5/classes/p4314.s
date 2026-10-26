# n=5 model=out iset=I1 prefix14_class=4314
cmp P2, P3
mov S2, P0
cmovle S0, P2
cmovle P2, P3
cmovg S0, P3
cmp P1, S2
cmovle S2, P1
cmovl P1, P0
mov P3, S0
cmp P3, S2
cmovle S0, S2
cmovle S2, P3
cmp P2, P1
mov S2, S0
