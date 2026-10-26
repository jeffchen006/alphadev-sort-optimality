# n=5 model=out iset=I1 prefix14_class=6833
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovle P1, S1
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovg S0, P2
cmovge P2, P0
cmp P1, P0
cmovl P0, P1
cmovl P1, P2
mov P1, P3
cmp S0, P1
