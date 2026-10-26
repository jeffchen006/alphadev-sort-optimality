# n=5 model=out iset=I1 prefix14_class=11014
cmp P1, P3
mov S2, P3
cmovge P3, P1
cmovge P1, S2
mov S0, P0
cmp P2, S0
cmovl S0, P2
cmovle P2, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmovl P3, P0
cmp P1, S0
cmovle P0, S0
