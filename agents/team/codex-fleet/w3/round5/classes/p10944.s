# n=5 model=out iset=I1 prefix14_class=10944
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovl P3, P1
cmp P2, P0
cmovg P1, P2
cmovg P2, P0
cmovg P0, P1
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovg S1, P0
cmp S2, P2
cmovl P0, P2
