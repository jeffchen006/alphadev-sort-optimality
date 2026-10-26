# n=5 model=out iset=I1 prefix14_class=9662
mov S1, P1
mov S2, P2
cmp P2, P0
cmovge S2, P0
cmovle P2, P0
cmp P1, P3
cmovl P1, P3
mov S0, P1
cmovl P3, S1
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmp S2, P3
cmovl P0, P3
