# n=5 model=out iset=I1 prefix14_class=12567
cmp P3, P1
cmovle S1, P1
cmovg S1, P3
cmovg P3, P1
cmp P2, P0
cmovl S2, P0
cmovle P0, P2
cmovl P2, S2
cmp P3, P0
mov S0, S1
mov P1, P0
cmovl P0, P3
cmovl P3, P1
cmovge P1, P3
