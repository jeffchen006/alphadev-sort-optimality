# n=5 model=out iset=I1 prefix14_class=2958
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovl S2, P2
mov P2, P0
cmp P2, P3
cmovge P2, P3
cmovge P3, P0
cmp P1, P3
cmovl P0, P3
cmovle P3, P1
cmovl P1, P0
cmp P2, S2
cmovg S1, S2
