# n=5 model=out iset=I1 prefix14_class=1923
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, P2
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
mov S0, P1
cmp P0, P1
cmovle S0, P0
cmovge P1, P0
mov P0, P2
cmp P2, P3
