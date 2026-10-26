# n=5 model=out iset=I1 prefix14_class=2354
mov S0, P0
cmp P0, P1
cmovl P0, P1
cmovle P1, S0
mov S1, P2
cmp P2, P3
cmovle P2, P3
cmovge S1, P3
cmp P0, P2
mov S0, P2
cmovle P2, P0
cmovge S0, P0
cmp P1, S1
cmovg P3, P1
