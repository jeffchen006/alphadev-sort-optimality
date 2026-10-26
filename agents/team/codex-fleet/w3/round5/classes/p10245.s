# n=5 model=out iset=I1 prefix14_class=10245
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
mov S1, P3
cmovle P2, S2
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmp P1, P0
cmovg S0, P0
mov P3, S1
cmovge P0, P1
cmovle S0, P1
mov P1, S0
