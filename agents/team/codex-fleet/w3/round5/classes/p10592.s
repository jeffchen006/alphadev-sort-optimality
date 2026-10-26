# n=5 model=out iset=I1 prefix14_class=10592
cmp P3, P2
cmovge S1, P3
mov S2, P1
cmovge P3, P2
cmovg P2, S1
cmp P0, P1
cmovg P1, P0
cmovl S2, P0
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
mov P0, S2
cmovle P2, S1
cmp P3, S2
