# n=5 model=out iset=I1 prefix14_class=1140
cmp P0, P1
mov S1, P3
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P2, S1
cmovge P3, P2
cmovge P2, S1
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovg S1, P0
cmp P1, P2
mov P0, P2
