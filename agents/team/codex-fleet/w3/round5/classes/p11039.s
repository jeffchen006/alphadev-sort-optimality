# n=5 model=out iset=I1 prefix14_class=11039
mov S2, P1
cmp P1, P0
cmovle P1, P0
cmovle P0, S2
mov S1, P3
cmp S1, P2
cmovle P3, P2
mov S0, P1
cmovl P2, S1
cmp P3, S0
cmovl S0, P3
cmovl P3, P1
cmp P0, P2
cmovge P1, P2
