# n=5 model=out iset=I1 prefix14_class=2402
cmp P1, P2
cmovl S0, P2
cmovge S0, P1
cmovge P1, P2
cmp P0, P3
mov P2, P0
cmovl P2, P3
cmovle P3, P0
cmp P2, S0
mov P0, S0
cmovge P0, P2
cmovg P2, S0
mov P0, P1
cmp P3, P0
