# n=5 model=out iset=I1 prefix14_class=4976
mov S0, P3
mov S2, P1
cmp P1, P2
cmovge S2, P2
cmovl P1, P2
cmovl P2, S2
cmp P0, P3
cmovg P3, P0
cmovge P0, S0
cmp P0, P2
cmovl P2, P0
cmovl P0, S2
mov S0, P0
mov P2, P3
