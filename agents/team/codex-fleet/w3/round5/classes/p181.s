# n=5 model=out iset=I1 prefix14_class=181
mov S1, P1
cmp P1, P2
cmovge P1, P2
cmovle S1, P2
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp P1, S0
cmovg S0, P1
cmovl P3, P1
mov S2, S0
mov P2, S1
