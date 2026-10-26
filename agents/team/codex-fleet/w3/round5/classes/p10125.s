# n=5 model=out iset=I1 prefix14_class=10125
cmp P2, P0
cmovg S0, P0
cmovle S0, P2
cmovge P0, P2
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovge S1, P1
cmp P0, P3
cmovle P2, P3
cmovle P3, P0
cmovl P0, P2
cmp S1, S0
cmovle P2, S1
