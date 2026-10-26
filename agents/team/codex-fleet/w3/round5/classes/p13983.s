# n=5 model=out iset=I1 prefix14_class=13983
cmp P0, P3
mov S0, P0
cmovl P0, P3
cmovl P3, S0
cmovl S0, P0
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmovge P1, S1
cmp P2, P0
cmovge P0, P2
cmovle S0, P2
mov P0, P1
cmp P3, P0
