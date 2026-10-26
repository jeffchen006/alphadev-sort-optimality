# n=5 model=out iset=I1 prefix14_class=12460
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
mov S1, P0
cmovl P1, S0
cmp P0, P2
cmovl P0, P2
cmovg S1, P2
cmovl P2, S1
cmp P1, S1
cmovl P2, P1
cmovg S1, P1
cmp P3, P0
cmovge P2, P3
