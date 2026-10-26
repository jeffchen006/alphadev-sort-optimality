# n=5 model=out iset=I1 prefix14_class=11555
mov S1, P1
cmp P3, S1
cmovle S1, P3
cmovge P1, P3
cmp P0, P2
mov P3, P2
cmovl P2, P0
cmovle P0, P3
cmp P2, S1
mov S0, S1
cmovl S1, P2
cmovl P2, S0
cmp P0, P1
cmovge S1, P1
