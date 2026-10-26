# n=5 model=out iset=I1 prefix14_class=6940
cmp P0, P1
mov S1, P0
cmovle S1, P1
cmovge P0, P1
mov P1, P2
cmp P3, P2
cmovg P1, P3
cmovl P2, P3
cmp S1, P1
mov S0, P1
cmovl P1, S1
cmovle S1, S0
cmp P0, P2
cmovl S0, P1
