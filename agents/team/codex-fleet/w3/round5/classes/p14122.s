# n=5 model=out iset=I1 prefix14_class=14122
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmovle S1, P0
cmp P3, P1
cmovle P0, P1
cmovl P1, P3
mov S2, S1
cmovle P3, P0
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovle P3, S0
cmp P1, S2
