# n=5 model=out iset=I1 prefix14_class=12676
cmp P0, P2
cmovge S0, P2
cmovg P2, P0
cmovl S0, P0
mov P0, S0
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovl P3, S2
cmp P0, P1
cmovl S0, P1
cmovge P0, P1
cmp P3, P2
mov P1, P2
