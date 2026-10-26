# n=5 model=out iset=I1 prefix14_class=9362
mov S2, P0
cmp P0, P3
cmovle P0, P3
cmovl P3, S2
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
mov S1, P3
cmovle P1, S0
cmp P2, S1
cmovge P3, P2
cmovge P2, S1
cmovg S1, P3
mov P2, P1
