# n=5 model=out iset=I1 prefix14_class=6588
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovge S0, P1
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
mov P1, P3
cmp P3, S0
cmovge P1, S0
cmovg S0, P3
cmp P2, P0
cmovge P3, P0
