# n=5 model=out iset=I1 prefix14_class=1753
cmp P2, P1
mov S2, P1
cmovge P1, P2
cmovg P2, S2
mov S2, P3
cmp P0, P3
cmovle P3, P0
cmovl P0, S2
cmp P1, P0
mov S0, P1
cmovl S0, P0
cmovge P1, P0
mov P0, P1
mov S0, P3
