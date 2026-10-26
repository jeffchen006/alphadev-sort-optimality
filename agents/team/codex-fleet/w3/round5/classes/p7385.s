# n=5 model=out iset=I1 prefix14_class=7385
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
mov S0, P0
cmovl P2, S1
cmp P0, P1
cmovg P0, P1
cmovg P1, S0
cmp P2, P0
cmovg S1, P0
cmovge P0, P2
mov S2, P3
cmovg P2, S1
cmp P1, P3
