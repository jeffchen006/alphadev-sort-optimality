# n=5 model=out iset=I1 prefix14_class=12365
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P2, P0
cmovle S0, P0
cmovg S0, P2
cmovg P2, P0
cmp P3, P2
cmovle S1, P3
cmovl P3, P2
cmovle P2, S1
mov P2, S0
mov S2, P3
