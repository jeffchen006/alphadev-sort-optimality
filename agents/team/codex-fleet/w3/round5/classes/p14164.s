# n=5 model=out iset=I1 prefix14_class=14164
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
mov S2, P1
cmovl P0, S0
mov S1, P0
cmp P2, S2
cmovg P1, P2
cmovg P2, S2
cmp P0, P1
cmovge P0, P1
cmovge P1, S1
cmp P2, P3
cmovge S1, P2
