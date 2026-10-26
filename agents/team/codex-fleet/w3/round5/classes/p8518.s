# n=5 model=out iset=I1 prefix14_class=8518
cmp P2, P3
cmovle S0, P3
mov S1, P0
cmovl P3, P2
cmovl P2, S0
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
mov P0, S1
cmp P2, S1
cmovg P0, P2
cmovle S1, P2
cmp P3, P1
mov P2, P3
