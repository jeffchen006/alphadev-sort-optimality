# n=5 model=out iset=I1 prefix14_class=3697
mov S0, P1
mov S1, P2
cmp P3, S1
cmovg P2, P3
cmovge P3, S1
cmp P1, P0
mov S1, P3
cmovl P1, P0
cmovle P0, S0
cmp S1, P0
cmovl S1, P0
cmovl P0, P3
mov P0, P2
cmovle P3, S1
