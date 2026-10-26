# n=5 model=out iset=I1 prefix14_class=1481
mov S1, P0
cmp S1, P3
cmovg S1, P3
cmovl P0, P3
mov S0, P1
cmovle P3, S1
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmp P0, S0
cmovg P1, S0
cmovge S0, P0
cmovg P0, P1
cmp P2, P3
