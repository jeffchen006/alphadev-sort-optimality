# n=5 model=out iset=I1 prefix14_class=2182
mov S1, P0
cmp P0, P1
cmovge P0, P1
cmovle S1, P1
cmp P2, P3
mov P1, P3
mov S0, S1
cmovle P1, P2
cmovl P2, P3
cmp P2, S0
cmovge S1, P2
cmovl S0, P2
cmp P1, P0
cmovle S2, P1
