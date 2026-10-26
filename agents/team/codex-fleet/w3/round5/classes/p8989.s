# n=5 model=out iset=I1 prefix14_class=8989
cmp P1, P2
cmovge S1, P2
mov S0, P3
cmovge P2, P1
cmovge P1, S1
cmp P3, P0
cmovl P3, P0
cmovge S0, P0
cmp P2, P3
cmovge P0, P3
cmovle P0, P2
cmovge P3, P2
cmp P1, S0
mov P3, P0
