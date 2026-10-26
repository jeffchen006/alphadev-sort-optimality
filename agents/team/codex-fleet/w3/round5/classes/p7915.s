# n=5 model=out iset=I1 prefix14_class=7915
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
mov S0, P0
cmp P2, S0
cmovle S0, P2
cmovge P0, P2
cmp P3, S0
cmovge P2, S0
cmovl P2, P3
cmovg S0, P3
cmp P1, P0
cmovle P2, P1
