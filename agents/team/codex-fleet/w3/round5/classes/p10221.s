# n=5 model=out iset=I1 prefix14_class=10221
cmp P0, P2
mov S0, P3
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P1, S0
cmovg S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P0, S0
cmovle S0, P0
cmovge P3, P0
cmp P1, P2
cmovle S2, P1
