# n=5 model=out iset=I1 prefix14_class=679
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
mov S1, P0
cmovge S0, P3
cmp S1, P2
cmovg S1, P2
cmovl P0, P2
cmp S0, P0
cmovle P3, P0
cmovle P0, S0
cmp S1, P1
mov S0, S1
