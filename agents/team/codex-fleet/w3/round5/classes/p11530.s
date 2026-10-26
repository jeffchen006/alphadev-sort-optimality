# n=5 model=out iset=I1 prefix14_class=11530
cmp P2, P3
cmovl S1, P2
cmovle P2, P3
mov S2, P0
cmovl P3, S1
mov S0, P3
cmp P1, S2
cmovle P0, P1
cmovle P1, S2
cmp S0, P0
cmovge P3, P0
cmovge P0, S0
mov S2, P0
cmp P1, P2
