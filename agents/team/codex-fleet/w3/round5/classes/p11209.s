# n=5 model=out iset=I1 prefix14_class=11209
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovle P0, S2
cmp P1, P2
cmovle S0, P1
cmovl P1, P2
cmovle P2, S0
cmp P0, P1
mov S0, P1
cmovge S0, P0
cmovg P0, P1
cmp P3, P2
cmovg S0, P2
