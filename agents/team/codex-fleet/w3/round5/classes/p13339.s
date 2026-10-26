# n=5 model=out iset=I1 prefix14_class=13339
cmp P3, P1
cmovg S0, P3
cmovge P3, P1
mov S1, P3
cmovg P1, S0
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
cmp P0, S1
cmovg P3, P0
cmovle S1, P0
cmp P1, P2
cmovl S1, P1
