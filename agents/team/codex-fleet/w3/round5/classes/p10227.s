# n=5 model=out iset=I1 prefix14_class=10227
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
mov S1, P3
cmovle P0, S0
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
mov S1, P2
cmp P3, S1
cmovg S1, P3
cmovle P2, P3
cmp P0, P1
cmovle S0, P0
