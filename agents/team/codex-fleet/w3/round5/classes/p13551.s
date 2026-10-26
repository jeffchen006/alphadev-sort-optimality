# n=5 model=out iset=I1 prefix14_class=13551
cmp P0, P2
cmovle S0, P0
cmovge S0, P2
cmovle P0, P2
cmp P1, P3
cmovle P2, P3
cmovle P3, P1
cmovl P1, P2
mov S1, P3
cmp S0, P3
cmovle S1, S0
cmovl S0, P3
cmp P0, P1
cmovg P3, P1
