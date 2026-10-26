# n=5 model=out iset=I1 prefix14_class=175
cmp P1, P2
cmovge S1, P1
mov S0, P0
cmovle S1, P2
cmovge P1, P2
cmp P3, S0
cmovle P0, P3
cmovl P3, S0
cmovle S0, P0
cmp P1, S0
cmovg S0, P1
cmovge P1, P0
cmp S1, P3
cmovge P0, S1
