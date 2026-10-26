# n=5 model=out iset=I1 prefix14_class=12734
mov S1, P1
cmp P0, S1
cmovl S1, P0
cmovg P1, P0
cmp P2, P3
cmovle S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P3, S1
mov P0, S1
cmovg S1, P3
cmovg P3, P0
cmp P2, P1
cmovle S2, P2
