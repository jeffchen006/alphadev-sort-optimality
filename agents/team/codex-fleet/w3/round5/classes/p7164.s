# n=5 model=out iset=I1 prefix14_class=7164
cmp P1, P0
mov S1, P0
cmovle P0, P1
cmovg S1, P1
cmovge P1, P0
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
cmp P0, P3
cmovl P1, P3
cmovge P0, P3
mov P3, P2
cmp P2, S1
