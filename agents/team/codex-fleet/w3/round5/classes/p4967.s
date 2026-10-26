# n=5 model=out iset=I1 prefix14_class=4967
mov S1, P0
cmp S1, P3
cmovle P0, P3
mov S0, P1
cmovg S1, P3
cmp S0, P2
cmovle P1, P2
cmovl P2, S0
cmovge S0, P2
cmp S1, S0
cmovl P2, S1
cmovle S1, S0
cmp P0, P1
mov P2, P1
