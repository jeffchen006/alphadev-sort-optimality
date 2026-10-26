# n=5 model=out iset=I1 prefix14_class=6473
mov S0, P3
mov S1, P0
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmp P2, S0
cmovle P3, P2
cmovge S0, P2
cmp S0, S1
cmovle S2, S0
cmovg S2, S1
cmovle S0, S1
cmp P1, P3
cmovl P0, P3
