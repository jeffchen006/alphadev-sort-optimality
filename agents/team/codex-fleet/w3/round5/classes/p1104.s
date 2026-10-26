# n=5 model=out iset=I1 prefix14_class=1104
cmp P0, P2
mov S0, P0
cmovl P0, P2
cmovle P2, S0
cmp P3, P1
cmovg S0, P3
mov S1, P0
cmovle S0, P1
cmovg P3, P1
cmp S1, S0
cmovle S1, S0
cmovle S0, P0
cmp P3, P2
cmovge S1, P3
