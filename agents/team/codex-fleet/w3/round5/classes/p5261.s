# n=5 model=out iset=I1 prefix14_class=5261
mov S0, P0
cmp P2, P0
cmovg S0, P2
cmovle P0, P2
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P3, P0
cmovl P2, P0
cmovge P2, P3
cmovg P3, P0
mov S2, P1
cmp P1, S0
