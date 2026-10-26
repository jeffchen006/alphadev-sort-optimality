# n=5 model=out iset=I1 prefix14_class=5092
mov S2, P3
cmp P0, P2
mov S1, P2
cmovle S1, P0
cmovle P0, P2
cmp P1, S2
cmovg P3, P1
cmovg P1, S2
cmp S1, P1
mov S0, P1
cmovge S0, S1
cmovl P1, S1
cmp P3, P0
cmovle P1, P0
