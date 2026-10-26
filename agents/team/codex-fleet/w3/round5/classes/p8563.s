# n=5 model=out iset=I1 prefix14_class=8563
cmp P2, P3
cmovg S1, P3
cmovg P3, P2
cmovle S1, P2
mov P2, P0
cmp P0, P1
cmovl P2, P1
cmovl P1, P0
cmp P3, P2
cmovl P0, P3
cmovge P0, P2
cmovg P2, P3
mov P3, P1
mov P2, P0
