# n=5 model=out iset=I1 prefix14_class=8074
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovg P2, P3
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
mov P3, P2
cmp P3, P0
cmovl P3, P0
cmovg P2, P0
cmp P1, S0
cmovl P2, S0
