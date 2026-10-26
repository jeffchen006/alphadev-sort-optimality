# n=5 model=out iset=I1 prefix14_class=6580
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
cmovl P3, P1
mov P1, P2
cmp P1, P0
cmovl P2, P0
cmovl P0, P1
cmp P2, P3
mov P1, P3
cmovle P1, P2
cmovge P3, P2
cmp S1, P0
cmovle P2, P0
