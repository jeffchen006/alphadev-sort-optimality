# n=5 model=out iset=I1 prefix14_class=4208
cmp P2, P0
cmovle S1, P0
cmovl P0, P2
cmovge S1, P2
mov S2, P1
cmp P1, P3
mov S0, P0
cmovle P1, P3
cmovle P3, S2
cmp P3, P0
cmovge P0, P3
cmovle S0, P3
cmp S1, P1
cmovg S0, S1
