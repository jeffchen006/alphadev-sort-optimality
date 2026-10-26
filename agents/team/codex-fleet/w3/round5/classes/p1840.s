# n=5 model=out iset=I1 prefix14_class=1840
mov S2, P0
cmp P0, P2
mov S1, P1
cmovl S2, P2
cmovle P2, P0
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
mov P1, S2
cmp P1, S1
cmovg S2, S1
cmovl P1, S1
cmovle S1, S2
mov P1, P2
