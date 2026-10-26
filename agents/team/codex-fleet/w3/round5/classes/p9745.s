# n=5 model=out iset=I1 prefix14_class=9745
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
mov S2, P1
cmovg P2, P3
cmp P0, P1
cmovl P1, P0
cmovle P0, S2
cmp P0, P2
mov S1, S0
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
mov P3, P0
