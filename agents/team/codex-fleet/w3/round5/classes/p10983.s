# n=5 model=out iset=I1 prefix14_class=10983
mov S1, P2
cmp S1, P0
cmovge P2, P0
cmovg P0, S1
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
cmovle S0, P1
