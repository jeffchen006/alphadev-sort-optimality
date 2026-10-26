# n=5 model=out iset=I1 prefix14_class=4901
mov S0, P3
cmp S0, P1
cmovl S0, P1
cmovle P1, P3
mov S1, P2
cmp P0, S1
cmovle P2, P0
cmovle P0, S1
cmp P1, P2
cmovg P3, P1
cmovge P1, P2
cmovle P3, P2
cmp S0, P0
cmovl P1, S0
