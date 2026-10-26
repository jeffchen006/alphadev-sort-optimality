# n=5 model=out iset=I1 prefix14_class=769
mov S1, P1
cmp P3, P1
mov S2, P0
cmovl S1, P3
cmovl P3, P1
cmp P0, P2
cmovge P0, P2
cmovl S2, P2
cmp P3, S2
cmovge S0, P3
cmovle S0, S2
cmovl S2, P3
mov S0, S2
mov P1, S1
