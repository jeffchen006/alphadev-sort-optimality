# n=5 model=out iset=I1 prefix14_class=10600
cmp P0, P3
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
mov S1, P2
cmp P1, S1
cmovg S1, P1
cmovle P2, P1
cmovl P1, S1
cmp S1, P3
cmovle S1, P3
cmovle P3, P1
cmp P2, P0
cmovge S1, P0
