# n=5 model=out iset=I1 prefix14_class=9079
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
cmovle P3, P1
cmp P2, S0
mov P1, P2
cmovge P2, S0
cmovle P1, S0
cmp P3, P0
cmovge P2, P0
