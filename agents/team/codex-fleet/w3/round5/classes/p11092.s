# n=5 model=out iset=I1 prefix14_class=11092
mov S0, P2
cmp P1, S0
cmovle P2, P1
cmovge S0, P1
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp S0, P3
cmovle P1, P3
cmovle P3, S0
cmovl S0, P1
cmp P0, P2
mov S1, P3
