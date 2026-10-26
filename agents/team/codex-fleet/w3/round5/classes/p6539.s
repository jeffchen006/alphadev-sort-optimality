# n=5 model=out iset=I1 prefix14_class=6539
cmp P0, P2
cmovl S2, P2
cmovge S2, P0
cmovl P2, P0
cmp P1, P3
cmovl P0, P3
cmovl P3, P1
cmovge P0, P1
cmovl P1, P0
cmp P1, S2
cmovl P0, S2
cmovg P1, S2
mov P0, P3
cmovle S2, P1
