# n=5 model=out iset=I1 prefix14_class=10718
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
mov S1, P1
cmovl P0, S2
cmp P3, S1
cmovl S1, P3
mov S0, P0
cmovge P1, P3
cmp P1, P0
cmovge P0, P1
cmovge P1, S0
cmp P2, S1
mov S0, P1
