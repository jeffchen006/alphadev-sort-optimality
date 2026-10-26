# n=5 model=out iset=I1 prefix14_class=11844
mov S1, P2
cmp P2, P0
cmovle P2, P0
mov S0, P2
cmovl P0, S1
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovle P3, S1
cmp P1, S0
cmovge P2, P1
mov P2, P3
cmovl S0, P1
cmp P0, P2
