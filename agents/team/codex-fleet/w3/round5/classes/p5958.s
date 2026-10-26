# n=5 model=out iset=I1 prefix14_class=5958
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovg S1, P1
mov P1, P0
cmp P1, P3
cmovge P0, P3
cmovg P3, P1
cmovl P1, P3
cmp P3, S1
cmovl P3, S1
cmovg P1, S1
cmp P0, P2
cmovle P3, P2
