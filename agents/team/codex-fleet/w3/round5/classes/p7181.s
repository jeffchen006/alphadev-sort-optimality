# n=5 model=out iset=I1 prefix14_class=7181
cmp P3, P0
mov S1, P2
cmovle S0, P3
cmovle P3, P0
cmovg S0, P0
cmp P1, S1
cmovl P2, P1
cmovle P1, S1
mov S1, P2
cmp P2, S0
cmovge P2, S0
cmovl S1, S0
cmp P1, P3
cmovl P2, P3
