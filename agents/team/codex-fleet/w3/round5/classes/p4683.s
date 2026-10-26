# n=5 model=out iset=I1 prefix14_class=4683
mov S0, P3
cmp P0, P3
cmovle P3, P0
cmovge S0, P0
cmp P2, P1
mov P0, P2
cmovge P2, P1
cmovl P0, P1
cmovge P1, P0
cmp P0, S0
cmovge P0, S0
cmovle P1, S0
cmp P2, P3
cmovge S2, P2
