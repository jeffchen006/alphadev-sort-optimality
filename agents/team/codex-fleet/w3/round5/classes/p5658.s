# n=5 model=out iset=I1 prefix14_class=5658
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
cmp P1, P2
mov S1, P1
cmovl P1, P2
cmovg S1, P2
mov P2, P3
cmp S1, P2
cmovle P2, S1
cmovl S1, P3
mov P2, S1
cmp P1, P0
