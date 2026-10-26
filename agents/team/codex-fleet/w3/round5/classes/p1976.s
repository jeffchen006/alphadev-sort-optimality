# n=5 model=out iset=I1 prefix14_class=1976
mov S0, P2
cmp P2, P1
mov S1, P0
cmovl P2, P1
cmovge S0, P1
cmp P3, S1
cmovl P0, P3
cmovge S1, P3
mov P3, P2
cmp P3, S1
cmovl P2, S1
cmovle S1, P3
mov P2, P0
mov P1, S1
