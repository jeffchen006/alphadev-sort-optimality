# n=5 model=out iset=I1 prefix14_class=10799
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmovle S1, P0
mov S0, P3
cmp P3, P1
cmovle P3, P1
cmovl P1, S0
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovle P2, S0
cmp P1, S1
cmovle P0, S1
